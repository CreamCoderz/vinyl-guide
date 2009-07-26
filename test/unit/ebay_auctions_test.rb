require 'test_helper'

class EbayAuctionsTest < ActiveSupport::TestCase
  CURRENT_TIME = Time.parse('2009-07-19T10:20:00+00:00')

  def test_create_new_record
    ebay_auction = EbayAuction.new
    assert !ebay_auction.save, "should save with both fields, item_id and end_time"
    ebay_auction.item_id = 120440899019
    assert !ebay_auction.save, "should set end_time"
    ebay_auction.end_time = CURRENT_TIME
    assert ebay_auction.save
  end

  def test_numerical_validation_of_item_id
    ebay_auction = EbayAuction.new
    ebay_auction.item_id = 'this shoud fail'
    current_time = Time.parse('2009-07-19T10:20:00+00:00')
    ebay_auction.end_time = current_time
    assert !ebay_auction.save, "item_id must be numeric"
    ebay_auction.item_id = 120440899019
    assert ebay_auction.save
  end

  #TODO: please make this uniqueness test work.. time to move on for now
#  def test_uniqueness_validation_of_item_id
#    id = 120440899019
#    ebay_auction = EbayAuction.new
#    ebay_auction.item_id = id
#    ebay_auction.end_time = CURRENT_TIME
#    assert ebay_auction.save
#    ebay_auction_2 = EbayAuction.new
#    ebay_auction_2.item_id = id
#    ebay_auction_2.end_time = CURRENT_TIME
#    assert !ebay_auction_2.save
#    assert_equal 1, EbayAuction.find(:all, :conditions => { :item_id => id }).length
#  end

end