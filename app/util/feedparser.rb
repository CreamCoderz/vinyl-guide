require 'cobravsmongoose'
require File.dirname(__FILE__) + '/../domain/recorddata'

class FeedParser
  def self.parse(rss)
    parsed_data = []
    rss_data = CobraVsMongoose.xml_to_hash(rss)
    items_node = rss_data['rss']['channel']['item']
    if items_node != nil
      items_node.each do |item|
        parsed_data.insert(parsed_data.length,
          RecordData.new(item['title']['$'], item['link']['$'], item['description']['$'], item['pubDate']['$']))
      end
    end
    parsed_data
  end
end
