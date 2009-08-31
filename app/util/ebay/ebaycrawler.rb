require 'activerecord'
require File.expand_path(File.dirname(__FILE__) + "/../../../config/environment")

class EbayCrawler

  CRAWLING_INTERVAL_SECONDS = 20 * 60

  def initialize(ebay_client)
    @ebay_client = ebay_client
  end

  def get_auctions
    current_time = @ebay_client.get_current_time
    auction_items = @ebay_client.find_items(current_time, current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS)
    auction_items.each do |auction_item|
      EbayAuction.new(:item_id => auction_item[0], :end_time => auction_item[1]).save
    end
  end

  def get_items
    current_time = @ebay_client.get_current_time
    ebay_auctions = EbayAuction.find(:all,
            :conditions => ["end_time < ?", current_time])
    if !ebay_auctions.empty?
      item_detailses = @ebay_client.get_details(ebay_auctions.map{ |ebay_auction| ebay_auction.item_id})
      item_detailses.each do |item_details|
        EbayItem.new(:itemid => item_details.itemid, :description => item_details.description, :bidcount => item_details.bidcount,
                :price => item_details.price, :endtime => item_details.endtime, :starttime => item_details.starttime,
                :url => item_details.url, :galleryimg => item_details.galleryimg,
                :sellerid => item_details.sellerid).save
      end
    end
  end
end