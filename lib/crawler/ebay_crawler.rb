require File.dirname(__FILE__) + '/../image_client'
require File.dirname(__FILE__) + '/../image_writer'

class EbayCrawler
  include ImageClient
  include ImageWriter

  #wasteful hack to get around ebay's current api issues: http://dev-forums.ebay.com/thread.jspa?threadID=500016830&start=15&tstart=0
  CRAWLING_INTERVAL_SECONDS = 20 * 60

  def initialize
    @ebay_client = EbayClient.new(VinylGuide::EBAY_API_KEY)
  end

  def get_auctions
    current_time = @ebay_client.get_current_time
    auction_items = @ebay_client.find_items(current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS)
    added_items = 0
    auction_items.each do |auction_item|
      ebay_auction = EbayAuction.new(:item_id => auction_item[0], :end_time => auction_item[1])
      added_items += 1 if ebay_auction.save
    end
    EBAY_CRAWLER_LOGGER.info("#{Time.new} found #{added_items} of #{auction_items.length} new auction items")
  end

  def get_items
    current_time = @ebay_client.get_current_time
    ebay_auctions = EbayAuction.where("end_time < ?", current_time)
    added_items_count, total_pictures, total_gallery = 0, 0, 0
    if ebay_auctions.present?
      @ebay_client.get_details(ebay_auctions.map { |ebay_auction| ebay_auction.item_id }) do |item_details|
        p 'creating ebay item...'
        ebay_item = EbayItem.new(:itemid => item_details.itemid, :title => item_details.title, :description => item_details.description,
                                 :bidcount => item_details.bidcount, :price => item_details.price, :endtime => item_details.endtime,
                                 :starttime => item_details.starttime, :url => item_details.url, :galleryimg => item_details.galleryimg,
                                 :sellerid => item_details.sellerid, :country => item_details.country, :size => item_details.size,
                                 :speed => item_details.speed, :condition => item_details.condition, :subgenre => item_details.subgenre,
                                 :currencytype => item_details.currencytype)
        if ebay_item.save
          p "created item: #{ebay_item.inspect}"
          added_items_count += 1
          pictureimgs = item_details.pictureimgs || []
          total_pictures += pictureimgs.select do |pictureimg|
            Picture.new(:ebay_item_id => ebay_item.id, :url => pictureimg).save
          end.length
          total_gallery += 1 if ebay_item.hasimage
        else
         p "failed to created item: #{ebay_item.itemid} - #{ebay_item.errors.full_messages}"
        end
      end
      ebay_auctions.destroy_all
    end
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{added_items_count} of #{ebay_auctions.length} new item details")
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{total_pictures} new pictures")
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{total_gallery} new gallery pictures")
  end

end