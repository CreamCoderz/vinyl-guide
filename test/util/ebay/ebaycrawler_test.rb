require 'test_helper'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../../../app/util/imageclient'
require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../spec/util/ebay/ebay_base_spec'
require File.dirname(__FILE__) + '/../../../spec/util/settablehttpclient'
include EbayBaseSpec

class EbayCrawlerTest < ActiveSupport::TestCase

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
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
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
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-20T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    check_ebay_item_and_data(TETRACK_EBAY_ITEM, actual_ebay_item)
    assert EbayAuction.find(:first, :conditions => {:item_id => TETRACK_ITEMID}).nil?
  end

  def test_get_items_fetches_images
    best_dressed = File.new(File.dirname(__FILE__) +"/../../../spec/data/best_dressed.jpg", "r").gets(nil)
    welton_irie = File.new(File.dirname(__FILE__) +"/../../../spec/data/welton_irie.jpg", "r").gets(nil)
    vital_dub = File.new(File.dirname(__FILE__) +"/../../../spec/data/vital_dub.jpg", "r").gets(nil)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({
            TETRACK_EBAY_ITEM.galleryimg => best_dressed,
            TETRACK_EBAY_ITEM.pictureimgs[0] => welton_irie,
            TETRACK_EBAY_ITEM.pictureimgs[1] => vital_dub})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, Dir.new(File.dirname(__FILE__) + "/../../../spec/data/tmp"))
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert_equal welton_irie, File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{actual_ebay_item.id}_0.jpg").gets(nil)
    assert_equal vital_dub, File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{actual_ebay_item.id}_1.jpg").gets(nil)
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery/#{actual_ebay_item.id}.jpg").gets(nil)
  end

  def test_fetch_nil_image
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client, Dir.new(File.dirname(__FILE__) + "/../../../spec/data/tmp"))
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert !File.exists?(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{actual_ebay_item.id}_0.jpg")
    assert !File.exists?(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery/#{actual_ebay_item.id}.jpg")
  end

  def test_ignores_default_image
    default_image = File.new(File.dirname(__FILE__) +"/../../../app/util/ebay/data/default_ebay_img.jpg", "r").gets(nil)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({TETRACK_EBAY_ITEM.galleryimg => default_image})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, Dir.new(File.dirname(__FILE__) + "/../../../spec/data/tmp"))
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert !File.exists?(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{actual_ebay_item.id}_0.jpg")
    assert !File.exists?(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery/#{actual_ebay_item.id}.jpg")
  end

  def test_does_not_write_to_existing_file
    best_dressed = File.new(File.dirname(__FILE__) +"/../../../spec/data/best_dressed.jpg", "r").gets(nil)
    junk_item_to_guess_next_id = EbayItem.new(:itemid => 1234212, :url => "http://www.junkitem.com/224", :bidcount => 4, :price => 10.00)
    assert junk_item_to_guess_next_id.save
    File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery/#{junk_item_to_guess_next_id.id + 1}.jpg", "w").syswrite(best_dressed)
    File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{junk_item_to_guess_next_id.id + 1}_0.jpg", "w").syswrite(best_dressed)
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    image_client = TestableImageClient.new({TETRACK_EBAY_ITEM.galleryimg => best_dressed,
            TETRACK_EBAY_ITEM.pictureimgs[0] => best_dressed})
    ebay_crawler = EbayCrawler.new(ebay_client, image_client, Dir.new(File.dirname(__FILE__) + "/../../../spec/data/tmp"))
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    assert_equal junk_item_to_guess_next_id.id + 1, actual_ebay_item.id
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery/#{actual_ebay_item.id}.jpg").gets(nil)
    assert_equal best_dressed, File.new(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures/#{actual_ebay_item.id}_0.jpg").gets(nil)
  end

  def test_no_get_details_call_made_if_no_items_to_fetch
    the_colonial_days = '1776-08-20T10:20:00+00:00'
    ebay_client = NilEbayClientClient.new(DateTime.parse(the_colonial_days), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    assert !ebay_client.get_details_called?
  end

  def test_get_item_with_no_picture
    #TODO: some timing issues.. fix this test.
    the_colonial_days = DateTime.parse('1776-08-20T10:20:00+00:00')
    current_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    item_id = 123435
    ebay_auction = EbayAuction.new({:item_id => item_id, :end_time => the_colonial_days})
    assert ebay_auction.save

    ebay_item = @data_builder.make
    ebay_item.endtime = the_colonial_days
    ebay_item.starttime = the_colonial_days
    ebay_item.itemid = item_id
    expected_item_data = ebay_item.to_data
    ebay_client = NilEbayClientClient.new(current_time, expected_item_data)
    ebay_crawler = EbayCrawler.new(ebay_client, @image_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => item_id})
    check_ebay_item_and_data(expected_item_data, actual_ebay_item)
  end

  #TODO: test for no auctions found
  class NilEbayClientClient < EbayClient

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

    def initialize(image_by_urls)
      @image_by_urls = image_by_urls
    end

    def fetch(url)
      @image_by_urls[url]
    end

  end
end