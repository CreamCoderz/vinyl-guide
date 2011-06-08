Dir.glob("#{Rails.root}/lib/crawler/*.{rb}").each { |file| require file }
Dir.glob("#{Rails.root}/lib/crawler/data/*.{rb}").each { |file| require file }
Dir.glob("#{Rails.root}/app/domain/*.{rb}").each { |file| require file }

properties_file = YAML.load_file("#{Rails.root}/config/build.#{Rails.env}.yml")
store_path = properties_file["store_path"]
ebay_api_key = properties_file["ebay_api_key"]
web_client = WebClient.new(Net::HTTP)
ebay_client = EbayClient.new(web_client, ebay_api_key)
ebay_crawler = EbayCrawler.new(ebay_client, ImageClient.new(web_client), Dir.new(store_path))
ebay_crawler.get_auctions
ebay_crawler.get_items
