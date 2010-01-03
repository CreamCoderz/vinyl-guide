require 'test_helper'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../../../spec/util/ebay/ebay_base_spec'
include EbayBaseSpec

class EbayCrawlerTest < ActiveSupport::TestCase

  def setup
    @data_builder = EbayItemDataBuilder.new
  end

  def test_get_auctions
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client)
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
    ebay_crawler = EbayCrawler.new(ebay_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => TETRACK_ITEMID})
    check_ebay_item_and_data(TETRACK_EBAY_ITEM, actual_ebay_item)
    assert EbayAuction.find(:first, :conditions => {:item_id => TETRACK_ITEMID}).nil?
  end

  def test_no_get_details_call_made_if_no_items_to_fetch
    the_colonial_days = '1776-08-20T10:20:00+00:00'
    ebay_client = NilEbayClientClient.new(DateTime.parse(the_colonial_days), TETRACK_EBAY_ITEM)
    ebay_crawler = EbayCrawler.new(ebay_client)
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
    ebay_crawler = EbayCrawler.new(ebay_client)
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
end