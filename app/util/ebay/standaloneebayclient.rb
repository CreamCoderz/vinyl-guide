require File.dirname(__FILE__) + '/ebayclient'
require File.dirname(__FILE__) + '/ebaycrawler'
require File.dirname(__FILE__) + '/../webclient'
require File.dirname(__FILE__) + '/../imageclient'
require File.dirname(__FILE__) + '/../dateutil'
require File.dirname(__FILE__) + '/../../../config/environment'

class StandAloneEbayClient
  web_client = WebClient.new(Net::HTTP)
  ebay_client = EbayClient.new( web_client)
  ebay_crawler = EbayCrawler.new(ebay_client, ImageClient.new(web_client), nil)
  ebay_crawler.get_auctions
  ebay_crawler.get_items
end
