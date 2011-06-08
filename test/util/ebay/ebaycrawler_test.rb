require 'test_helper'
require File.dirname(__FILE__) + '/../../../lib/crawler/ebay_client'
require File.dirname(__FILE__) + '/../../../lib/crawler/ebay_crawler'
require File.dirname(__FILE__) + '/../../../lib/image_client'
require File.dirname(__FILE__) + '/../../../lib/web_client'
require File.dirname(__FILE__) + '/../../../spec/lib/crawler/ebay_base_spec'
require File.dirname(__FILE__) + '/../../../spec/lib/settable_http_client'
include EbayBaseSpec

class EbayCrawlerTest < ActiveSupport::TestCase

  TEMP_DATA_PATH = "/../../../spec/data/tmp"
  TEMP_DATA_DIR = Dir.new(File.dirname(__FILE__) + TEMP_DATA_PATH)
  GALLERY_IMG_PATH = "/../../../spec/data/tmp/gallery/"
  PICTURE_IMG_PATH = "/../../../spec/data/tmp/pictures/"
  THE_COLONIAL_DAYS = DateTime.parse('1776-08-20T10:20:00+00:00')
  ITEM_ID = 12345

  def setup
    @data_builder = EbayItemDataBuilder.new
    @image_client = ImageClient.new(WebClient.new(SettableHttpClient.new(nil, nil)))
    FileUtils.mkdir(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery")
    FileUtils.mkdir(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures")
  end

  def teardown
    FileUtils.rm_rf(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery")
    FileUtils.rm_rf(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures")
  end

  def test_get_auctions
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_auctions
    stored_auction = EbayAuction.find(:first, :conditions => {:item_id => FOUND_ITEM_1[0]})
    assert_equal FOUND_ITEM_1[0], stored_auction.item_id
    assert_equal FOUND_ITEM_1[1], stored_auction.end_time
  end

  def test_get_items
    base_time = DateTime.new
    future_time = DateTime.parse('2009-08-21T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => 120440899019, :end_time => future_time})
    assert ebay_auction.save
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-20T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    check_ebay_item_and_data(TETRACK_EBAY_ITEM, actual_ebay_item)
    assert EbayAuction.find(:first, :conditions => {:item_id => TETRACK_ITEMID}).nil?
  end

  #TODO: begin these tests are being moved to image_injector_spec

  def test_get_items_fetches_images
    best_dressed = File.new(File.dirname(__FILE__) +"/../../../spec/data/best_dressed.jpg", "r").gets(nil)
    welton_irie = File.new(File.dirname(__FILE__) +"/../../../spec/data/welton_irie.jpg", "r").gets(nil)
    vital_dub = File.new(File.dirname(__FILE__) +"/../../../spec/data/vital_dub.jpg", "r").gets(nil)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({
            TETRACK_EBAY_ITEM.galleryimg => best_dressed,
            TETRACK_EBAY_ITEM.pictureimgs[0] => welton_irie,
            TETRACK_EBAY_ITEM.pictureimgs[1] => vital_dub})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, TEMP_DATA_DIR)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert_equal welton_irie, File.new(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{actual_ebay_item.id}_0.jpg").gets(nil)
    assert actual_ebay_item.pictures[0].hasimage
    assert actual_ebay_item.pictures[1].hasimage
    assert_equal vital_dub, File.new(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{actual_ebay_item.id}_1.jpg").gets(nil)
    assert actual_ebay_item.hasimage
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{actual_ebay_item.id}.jpg").gets(nil)
  end

  def test_fetch_nil_image
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client, TEMP_DATA_DIR)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert !File.exists?(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{actual_ebay_item.id}_0.jpg")
    assert !actual_ebay_item.pictures[0].hasimage
    assert !File.exists?(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{actual_ebay_item.id}.jpg")
    assert !actual_ebay_item.hasimage
  end

  def test_ignores_default_image
    default_image = File.new(File.dirname(__FILE__) +"/../../../lib/crawler/data/default_ebay_img.jpg", "r").gets(nil)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({TETRACK_EBAY_ITEM.galleryimg => default_image})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, TEMP_DATA_DIR)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert !File.exists?(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{actual_ebay_item.id}_0.jpg")
    assert !File.exists?(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{actual_ebay_item.id}.jpg")
  end

  def test_does_not_fetch_nil_gallery_img
    ebay_auction = EbayAuction.new({:item_id => ITEM_ID, :end_time => THE_COLONIAL_DAYS})
    assert ebay_auction.save
    ebay_item = @data_builder.make
    ebay_item.endtime = THE_COLONIAL_DAYS
    ebay_item.starttime = THE_COLONIAL_DAYS
    ebay_item.itemid = ITEM_ID
    ebay_item.galleryimg = nil
    expected_item_data = ebay_item.to_data
    current_time = DateTime.parse('2010-01-31T10:20:00+00:00')
    ebay_client = SettableEbayClient.new(current_time, expected_item_data)
    image_client = TestableImageClient.new({nil => "Empty Image Body"}, false)
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, TEMP_DATA_DIR)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => ITEM_ID})
    assert !File.exists?(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{actual_ebay_item.id}.jpg")
    assert !actual_ebay_item.hasimage
  end

  def test_does_not_write_to_existing_file
    best_dressed = File.new(File.dirname(__FILE__) +"/../../../spec/data/best_dressed.jpg", "r").gets(nil)
    junk_item_to_guess_next_id = EbayItem.new(:itemid => 1234212, :url => "http://www.junkitem.com/224", :bidcount => 4, :price => 10.00)
    assert junk_item_to_guess_next_id.save
    File.new(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{junk_item_to_guess_next_id.id + 1}.jpg", "w").syswrite(best_dressed)
    File.new(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{junk_item_to_guess_next_id.id + 1}_0.jpg", "w").syswrite(best_dressed)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = SettableEbayClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({TETRACK_EBAY_ITEM.galleryimg => best_dressed,
            TETRACK_EBAY_ITEM.pictureimgs[0] => best_dressed})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, TEMP_DATA_DIR)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert_equal junk_item_to_guess_next_id.id + 1, actual_ebay_item.id
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "#{GALLERY_IMG_PATH}#{actual_ebay_item.id}.jpg").gets(nil)
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "#{PICTURE_IMG_PATH}#{actual_ebay_item.id}_0.jpg").gets(nil)
  end

  #TODO: end these tests are being moved

  def test_no_get_details_call_made_if_no_items_to_fetch
    ebay_client = SettableEbayClient.new(THE_COLONIAL_DAYS, TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    assert !ebay_client.get_details_called?
  end

  def test_get_item_with_no_picture
    #TODO: some timing issues.. fix this test.
    current_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => ITEM_ID, :end_time => THE_COLONIAL_DAYS})
    assert ebay_auction.save

    ebay_item = @data_builder.make
    ebay_item.endtime = THE_COLONIAL_DAYS
    ebay_item.starttime = THE_COLONIAL_DAYS
    ebay_item.itemid = ITEM_ID
    expected_item_data = ebay_item.to_data
    ebay_client = SettableEbayClient.new(current_time, expected_item_data)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => ITEM_ID})
    check_ebay_item_and_data(expected_item_data, actual_ebay_item)
  end

  #TODO: test for no auctions found
  class SettableEbayClient < EbayClient

    def initialize(current_time, expected_item)
      @current_time = current_time
      @called = false
      @expected_item = expected_item
    end

    def find_items(end_time_to)
      if end_time_to == @current_time + 1200
        return [FOUND_ITEM_1]
      end
      nil
    end

    def get_details(item_ids)
      @called = true
      if item_ids.include? @expected_item.itemid
        return [@expected_item]
      end
      []
    end

    def get_details_called?
      @called
    end

    def get_current_time
      @current_time
    end
  end

  class TestableImageClient < ImageClient

    def initialize(image_by_urls, should_receive_fetch=true)
      @image_by_urls = image_by_urls
      @should_receive_fetch = should_receive_fetch
    end

    def fetch(url)
      unless @should_receive_fetch
        raise Exception.new('fetch should not have been called')
      end
      @image_by_urls[url]
    end

  end
end