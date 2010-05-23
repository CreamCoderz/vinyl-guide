require 'test_helper'
require File.dirname(__FILE__) + '/../../spec/lib/crawler/ebay_base_spec'
include BaseTestCase

class EbayItemsTest < ActiveSupport::TestCase
  ITEM_ID = 12345678901

  def test_create_new_ebay_item
    ebay_item = EbayItem.new
    assert !ebay_item.save, "should not be able to save without item id"
    ebay_item = EbayItem.new(:itemid => EbayBaseData::TETRACK_EBAY_ITEM.itemid, :title => EbayBaseData::TETRACK_EBAY_ITEM.title,
            :description => EbayBaseData::TETRACK_EBAY_ITEM.description, :bidcount => EbayBaseData::TETRACK_EBAY_ITEM.bidcount,
            :price => EbayBaseData::TETRACK_EBAY_ITEM.price, :endtime => EbayBaseData::TETRACK_EBAY_ITEM.endtime,
            :starttime => EbayBaseData::TETRACK_EBAY_ITEM.starttime, :url => EbayBaseData::TETRACK_EBAY_ITEM.url,
            :galleryimg => EbayBaseData::TETRACK_EBAY_ITEM.galleryimg, :sellerid => EbayBaseData::TETRACK_EBAY_ITEM.sellerid,
            :pictures => EbayBaseData::TETRACK_EBAY_ITEM.pictureimgs.map {|pictureimg| Picture.new(:ebay_item_id => ebay_item.id, :url => pictureimg)},
            :country => EbayBaseData::TETRACK_EBAY_ITEM.country, :size => EbayBaseData::TETRACK_EBAY_ITEM.size, :speed => EbayBaseData::TETRACK_EBAY_ITEM.speed,
            :condition => EbayBaseData::TETRACK_EBAY_ITEM.condition, :subgenre => EbayBaseData::TETRACK_EBAY_ITEM.subgenre,
            :currencytype => EbayBaseData::TETRACK_EBAY_ITEM.currencytype)
    assert ebay_item.save
    stored_item = EbayItem.find(ebay_item.id)
    check_ebay_item_and_data(EbayBaseData::TETRACK_EBAY_ITEM, stored_item)
  end

  def test_numerical_field_types
    ebay_item = EbayItem.new(:itemid => ITEM_ID)
    ebay_item.price = "teh price"
    assert !ebay_item.save, "should be a float value for the price"
    ebay_item.price = 33.10
    ebay_item.bidcount = "bidcount"
    assert !ebay_item.save, "should be a numerical bidcount"
    ebay_item.bidcount = 10
    ebay_item.url = "http://www.example.com/1"
    assert ebay_item.save
    stored_item = EbayItem.find(ebay_item.id)
    assert_equal stored_item.itemid, ITEM_ID
  end

  def test_presense_of_url
    ebay_item = EbayItem.new(:itemid => ITEM_ID)
    ebay_item.bidcount = 10
    ebay_item.price = 55.99
    assert !ebay_item.save, "should specify and url"
    ebay_item.url = "http://www.example.com/1"
    assert ebay_item.save
  end


  def test_has_pictures
    ebay_item = make_basic_ebay_item()
    picture_1 = Picture.new(:ebay_item_id => ebay_item.id, :url => "http://www.example.com/2")
    picture_2 = Picture.new(:ebay_item_id => ebay_item.id, :url => "http://www.example.com/3")
    pictures = [picture_1, picture_2]
    ebay_item.pictures = pictures
    assert ebay_item.save
    stored_item = EbayItem.find(ebay_item.id)
    assert_equal pictures, stored_item.pictures
  end

  def test_set_empty_pictures
    picture_count = Picture.find(:all).length
    ebay_item = make_basic_ebay_item()
    ebay_item.pictures = []
    ebay_item.save()
    assert_equal picture_count, Picture.find(:all).length
  end

  def make_basic_ebay_item()
    ebay_item = EbayItem.new(:itemid => ITEM_ID)
    ebay_item.bidcount = 10
    ebay_item.price = 55.99
    ebay_item.url = "http://www.example.com/1"
    ebay_item
  end
end