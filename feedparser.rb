require 'cobravsmongoose'
require 'recorddata'

class FeedParser
  def self.parse(rss)
    parsedData = [] 
    rssData = CobraVsMongoose.xml_to_hash(rss)
    itemsNode = rssData['rss']['channel']['item']
    if itemsNode != nil
      itemsNode.each do |item|
        parsedData.insert(parsedData.length, 
          RecordData.new(item['title']['$'], item['link']['$'], item['description']['$'], item['pubDate']['$']))
      end
    end
    parsedData     
  end
end
