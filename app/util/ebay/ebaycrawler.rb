require 'activerecord'
require File.expand_path(File.dirname(__FILE__) + "/../../../config/environment")

class EbayCrawler

  CRAWLING_INTERVAL_SECONDS = 20 * 60

  def initialize(ebay_client)
    @ebay_client = ebay_client
  end

  #TODO: test this method (the ActiveRecord part)!!

  def crawl
    current_time = @ebay_client.get_current_time
    auction_items = @ebay_client.find_items(current_time, current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS)
    auction_items.each do |auction_item|
      ebay_auction_item = EbayAuction.new
      ebay_auction_item.item_id = auction_item[0]
      ebay_auction_item.end_time = auction_item[1]
      ebay_auction_item.save
    end
  end

  #TODO: test this method (in progress in Test::Unit)

  def get_items
    item_ids = []
    current_time = @ebay_client.get_current_time
    ebay_auctions = EbayAuction.find(:all)
    #TODO: handle nil for no auctions found
    #TODO: update records accordingly

    ebay_auctions.each do |ebay_auction|
#      if (current_time <=> ebay_auction.end_time) == -1
        item_ids.insert(-1, ebay_auction.item_id)
#        ebay_auction.delete
#      end
    end
    puts item_ids
    #TODO: only call out if there are actual items to fetch
    item_detailses = @ebay_client.get_details(item_ids)
    item_detailses.each do |item_details|
      puts 'create item ' + item_details.itemid.to_s
      ebay_item = EbayItem.new(:itemid => item_details.itemid, :description => item_details.description, :bidcount => item_details.bidcount,
              :price => item_details.price, :endtime => item_details.endtime, :starttime => item_details.starttime,
              :url => item_details.url, :galleryimg => item_details.galleryimg,
              :sellerid => item_details.sellerid)
      ebay_item.save
    end
  end
end