require File.dirname(__FILE__) + '/ebayclient'
require File.dirname(__FILE__) + '/ebaycrawler'
require File.dirname(__FILE__) + '/../webclient'
require File.dirname(__FILE__) + '/../dateutil'
require File.dirname(__FILE__) + '/../../../config/environment'

class StandAloneEbayClient
  ebay_client = EbayClient.new(WebClient.new(Net::HTTP))
  ebay_crawler = EbayCrawler.new(ebay_client)
  ebay_crawler.get_auctions
  ebay_crawler.get_items
end
