require 'cobravsmongoose'
require 'recorddata'

class FeedParser
  def self.parse(rss)
    @parsedData = [] 
    @rssData = CobraVsMongoose.xml_to_hash(rss)
    @rssData['rss']['channel']['item'].each do |item|
      @parsedData.insert(@parsedData.length, RecordData.new(item['title']['$']))
    end
    @parsedData     
  end
end
