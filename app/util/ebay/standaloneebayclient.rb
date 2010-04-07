require File.dirname(__FILE__) + '/ebayclient'
require File.dirname(__FILE__) + '/ebaycrawler'
require File.dirname(__FILE__) + '/../webclient'
require File.dirname(__FILE__) + '/../imageclient'
require File.dirname(__FILE__) + '/../dateutil'
require File.dirname(__FILE__) + '/../../../config/environment'

properties_file = YAML.load_file("../../../config/build.#{Rails.env}.yml")
store_path = properties_file['store_path']
ebay_api_key = properties_file['ebay_api_key']
web_client = WebClient.new(Net::HTTP)
ebay_client = EbayClient.new(web_client, ebay_api_key)
ebay_crawler = EbayCrawler.new(ebay_client, ImageClient.new(web_client), Dir.new(store_path))
ebay_crawler.get_auctions
ebay_crawler.get_items
