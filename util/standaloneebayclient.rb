Dir.glob("#{Rails.root}/lib/crawler/*.{rb}").each { |file| require file }
Dir.glob("#{Rails.root}/lib/crawler/data/*.{rb}").each { |file| require file }
Dir.glob("#{Rails.root}/app/domain/*.{rb}").each { |file| require file }

Signal.trap("ALRM") { puts caller.join("\n") }

ebay_crawler = EbayCrawler.new
ebay_crawler.get_auctions
ebay_crawler.get_items
