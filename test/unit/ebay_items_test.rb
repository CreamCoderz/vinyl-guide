require 'test_helper'
require File.dirname(__FILE__) + '/../../spec/base_spec_case'
include BaseTestCase

class EbayItemsTest < ActiveSupport::TestCase
  ITEM_ID = 12345678901

  def test_create_new_ebay_item
    ebay_item = EbayItem.new
    assert !ebay_item.save, "should not be able to save without item id"
    ebay_item = EbayItem.new(:itemid => BaseSpecCase::TETRACK_EBAY_ITEM.itemid, :description => BaseSpecCase::TETRACK_EBAY_ITEM.description, :bidcount => BaseSpecCase::TETRACK_EBAY_ITEM.bidcount,
            :price => BaseSpecCase::TETRACK_EBAY_ITEM.price, :endtime => BaseSpecCase::TETRACK_EBAY_ITEM.endtime, :starttime => BaseSpecCase::TETRACK_EBAY_ITEM.starttime,
            :url => BaseSpecCase::TETRACK_EBAY_ITEM.url, :galleryimg => BaseSpecCase::TETRACK_EBAY_ITEM.galleryimg, :sellerid => BaseSpecCase::TETRACK_EBAY_ITEM.sellerid)
    assert ebay_item.save
    stored_item = EbayItem.find(ebay_item.id)
    check_ebay_item_and_data(BaseSpecCase::TETRACK_EBAY_ITEM, stored_item)
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
end