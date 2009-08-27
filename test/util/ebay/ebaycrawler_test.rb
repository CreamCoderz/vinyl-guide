require 'test_helper'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../../../spec/base_spec_case'

class EbayCrawlerTest < ActiveSupport::TestCase

  def test_get_items
    future_time = Time.new + 60 * 10
    ebay_auction = EbayAuction.new({:item_id => 120440899019, :end_time => future_time})
    assert ebay_auction.save
    past_time = Time.new - (60 * 10)
    ebay_auction = EbayAuction.new({:item_id => BaseSpecCase::TETRACK_ITEMID, :end_time => past_time})
    assert ebay_auction.save
    ebay_crawler = EbayCrawler.new(NilEbayClientClient.new)
    ebay_crawler.get_items
    actual_ebay_item = EbayItem.find(:first, :conditions => {:itemid => BaseSpecCase::TETRACK_ITEMID})
    assert_equal BaseSpecCase::TETRACK_EBAY_ITEM.description, actual_ebay_item.description
  end

  class NilEbayClientClient < EbayClient
    def initialize
    end

    def find_items
    end

    def get_details(item_id)
#      puts item_id
#      if item_id == BaseSpecCase::TETRACK_ITEMID
        return [BaseSpecCase::TETRACK_EBAY_ITEM]
#      end
#      []
    end

    def get_current_time
    end
  end
end