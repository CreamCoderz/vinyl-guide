require 'activerecord'
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/ebaylogger")
include EbayLogger

class EbayCrawler

  CRAWLING_INTERVAL_SECONDS = 20 * 60
  DEFAULT_EBAY_IMAGE = File.new(File.dirname(__FILE__) + "/data/default_ebay_img.jpg").gets(nil)

  def initialize(ebay_client, image_client, image_dir=nil)
    @ebay_client = ebay_client
    @image_client = image_client
    @image_dir = image_dir
  end

  def get_auctions
    current_time = @ebay_client.get_current_time
    auction_items = @ebay_client.find_items(current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS)
    added_items = 0
    auction_items.each do |auction_item|
      ebay_auction = EbayAuction.new(:item_id => auction_item[0], :end_time => auction_item[1])
      added_items = save_item(added_items, ebay_auction)
    end
    EBAY_CRAWLER_LOGGER.info("#{Time.new} found #{added_items} of #{auction_items.length} new auction items")
  end

  def get_items
    current_time = @ebay_client.get_current_time
    ebay_auctions = EbayAuction.find(:all,
            :conditions => ["end_time < ?", current_time])
    added_items_count = 0
    total_pictures = 0
    total_gallery = 0
    if !ebay_auctions.empty?
      item_detailses = @ebay_client.get_details(ebay_auctions.map{ |ebay_auction| ebay_auction.item_id})
      item_detailses.each do |item_details|
        ebay_item = EbayItem.new(:itemid => item_details.itemid, :title => item_details.title, :description => item_details.description,
                :bidcount => item_details.bidcount, :price => item_details.price, :endtime => item_details.endtime,
                :starttime => item_details.starttime, :url => item_details.url, :galleryimg => item_details.galleryimg,
                :sellerid => item_details.sellerid, :country => item_details.country, :size => item_details.size,
                :speed => item_details.speed, :condition => item_details.condition, :subgenre => item_details.subgenre,
                :currencytype => item_details.currencytype)
        pictures = []
        if item_details.pictureimgs
          pictures = item_details.pictureimgs.map {|pictureimg| Picture.new(:ebay_item_id => ebay_item.id, :url => pictureimg)}
        end
        ebay_item.pictures = pictures
        added_items_count = save_item(added_items_count, ebay_item)
        if (@image_dir)
          num_pictures, num_gallery = inject_images(ebay_item)
          total_pictures += num_pictures
          total_gallery += num_gallery
        end
      end
      ebay_auctions.map { |ebay_auction| ebay_auction.delete }
    end
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{added_items_count} of #{ebay_auctions.length} new item details")
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{total_pictures} new pictures")
    EBAY_CRAWLER_LOGGER.info("#{Time.new} added #{total_gallery} new gallery pictures")
  end

  private

  def save_item(added_items_count, ebay_item)
    if ebay_item.save
      added_items_count += 1
    end
    return added_items_count
  end

  def inject_images(ebay_item)
    num_pictures = 0
    num_gallery = 0
    ebay_item.pictures.each do |picture|
      image_name = "/pictures/#{ebay_item.id}_#{num_pictures}.jpg"
      if write_image(image_name, @image_client.fetch(picture.url))
        num_pictures += 1
        #TODO: test this
        picture.hasimage = true
        picture.save
      end
    end
    if ebay_item.galleryimg and write_image("/gallery/#{ebay_item.id}.jpg", @image_client.fetch(ebay_item.galleryimg))
      num_gallery += 1
      ebay_item.hasimage = true
      ebay_item.save
    end
    return [num_pictures, num_gallery]
  end

  def write_image(image_name, image_content)
    if (verify_image(image_content))
      f = File.new(@image_dir.path + image_name, "w")
      f.syswrite(image_content)
      return true
    end
    return false
  end

  def verify_image(image_content)
    verified = false
    if (image_content)
      verified = !(DEFAULT_EBAY_IMAGE == image_content)
    end
    verified
  end
end