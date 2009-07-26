require 'test_helper'

class EbayItemsTest < ActiveSupport::TestCase
  ITEM_ID = 12345

  def test_create_new_ebay_item
    ebay_item = EbayItem.new
    assert !ebay_item.save, "should not be able to save without item id"
    ebay_item = EbayItem.new(:itemid => ITEM_ID, :description => "the description", :bidcount => 10,
            :price => 55.00, :endtime => Time.new, :starttime => Time.new,
            :url => "http://www.example.com/1", :galleryimg => "http://imgurl.com/1",
            :sellerid => "onlyroots")
    assert ebay_item.save
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