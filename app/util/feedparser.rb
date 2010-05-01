require 'rubygems'
require 'cobravsmongoose'
require File.dirname(__FILE__) + '/../domain/recorddata'

module FeedParser
  def self.parse(rss)
    rss_data = CobraVsMongoose.xml_to_hash(rss)
    items_node = rss_data['rss']['channel']['item']
    parsed_data = []
    if items_node
      items_node.each { |item| parsed_data << RecordData.new(item['title']['$'], item['link']['$'], item['description']['$'], item['pubDate']['$']) }
    end
    parsed_data
  end
end
