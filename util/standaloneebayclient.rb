require File.dirname(__FILE__) + '/../lib/crawler/ebay_client'
require File.dirname(__FILE__) + '/../lib/crawler/ebay_crawler'
require File.dirname(__FILE__) + '/../lib/web_client'
require File.dirname(__FILE__) + '/../lib/imageclient'
require File.dirname(__FILE__) + '/../lib/date_util'
require File.dirname(__FILE__) + '/../config/environment'

properties_file = YAML.load_file(File.dirname(__FILE__) + "/../config/build.#{Rails.env}.yml")
store_path = properties_file['store_path']
ebay_api_key = properties_file['ebay_api_key']
web_client = WebClient.new(Net::HTTP)
ebay_client = EbayClient.new(web_client, ebay_api_key)
ebay_crawler = EbayCrawler.new(ebay_client, ImageClient.new(web_client), Dir.new(store_path))
ebay_crawler.get_auctions
ebay_crawler.get_items
