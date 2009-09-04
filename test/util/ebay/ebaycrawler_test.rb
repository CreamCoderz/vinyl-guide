require 'test_helper'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../../../spec/base_spec_case'

class EbayCrawlerTest < ActiveSupport::TestCase

  def test_get_auctions
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-30T10:20:00+00:00'))
    ebay_crawler = EbayCrawler.new(ebay_client)
    ebay_crawler.get_auctions
    stored_auction = EbayAuction.find(:first, :conditions => {:item_id => BaseSpecCase::FOUND_ITEM_1[0]})
    assert_equal BaseSpecCase::FOUND_ITEM_1[0], stored_auction.item_id
    assert_equal BaseSpecCase::FOUND_ITEM_1[1], stored_auction.end_time
  end
  
  def test_get_items
    base_time = DateTime.new
    future_time = DateTime.parse('2009-08-21T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => 120440899019, :end_time => future_time})
    assert ebay_auction.save
    past_time = DateTime.parse('2009-08-19T10:20:00+00:00')
    ebay_auction = EbayAuction.new({:item_id => BaseSpecCase::TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_client = NilEbayClientClient.new(DateTime.parse('2009-08-20T10:20:00+00:00'))
    ebay_crawler = EbayCrawler.new(ebay_client)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => BaseSpecCase::TETRACK_ITEMID})
    check_ebay_item_and_data(BaseSpecCase::TETRACK_EBAY_ITEM, actual_ebay_item)
    assert EbayAuction.find(:first, :conditions => {:item_id => BaseSpecCase::TETRACK_ITEMID}).nil?
  end

  def test_no_get_details_call_made_if_no_items_to_fetch
    the_colonial_days = '1776-08-20T10:20:00+00:00'
    ebay_client = NilEbayClientClient.new(DateTime.parse(the_colonial_days))
    ebay_crawler = EbayCrawler.new(ebay_client)
    ebay_crawler.get_items
    assert !ebay_client.get_details_called?
  end


  #TODO: test for no auctions found
  class NilEbayClientClient < EbayClient

    def initialize(current_time)
      @current_time = current_time
      @called = false
    end

    def find_items(start_time, end_time)
      [BaseSpecCase::FOUND_ITEM_1]
    end

    def get_details(item_ids)
      @called = true
      if item_ids.include? BaseSpecCase::TETRACK_ITEMID
        return [BaseSpecCase::TETRACK_EBAY_ITEM]
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