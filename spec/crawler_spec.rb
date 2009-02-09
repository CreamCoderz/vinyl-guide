require 'net/http'
require 'uri'
require 'crawler'
require 'spec/feedparser_spec'

describe Crawler do
  URL = "http://rss.example.com/index.html"
  
  it "should make a get request for a given url" do
    @httpClient = SettableHttpClient.new 'unused' 
    @expectedResponse = "<?xml version =\"1.0\">\n" +
			    "<rss version=\"2.0\">\n" +
			   "</rss>\n"+
			  "</xml>"
    @httpClient.response = @expectedResponse
    @crawler = Crawler.new(@httpClient, URL)
    @actualResponse = @crawler.get
    @actualResponse.getResponseClass.should == Net::HTTPSuccess 
    @actualResponse.body.should == @expectedResponse
    @httpClient.host.should == "rss.example.com"
    @httpClient.port.should == 80
    @httpClient.path.should == "/index.html" 
  end

  it "should parse request into an array of records" do
    @httpClient = SettableHttpClient.new 'unused' 
    @httpClient.response = FeedParserSpec::FEED_HEADER + FeedParserSpec::FEED_FOOTER 
    @crawler = Crawler.new(@httpClient, URL)
    @actualResults = @crawler.crawl
    @actualResults.length.should == 0
    @httpClient.response = FeedParserSpec::FEED_WITH_ITEMS
    @actualResults = @crawler.crawl 
    @actualResults.length.should == 2
    FeedParserSpec.checkFeedItem(@actualResults[0], FeedParserSpec::JAZZBO_RECORD) 
    FeedParserSpec.checkFeedItem(@actualResults[1], FeedParserSpec::CONGOS_RECORD) 
  end
  
  #TODO: test response failure on crawl

  class SettableHttpClient<Net::HTTP
 
    def host
      @host
    end

    def port 
      @port
    end

    def path 
      @path
    end

    def start(host, port)
      @host = host
      @port = port
      yield self
    end

    def response= (xml)
      @xml = xml 
    end

    def get(path)
      @path = path
      @response = SettableHTTPSuccessResponse.new("1.1", "2", "SUCCESS")
      @response.body = @xml
      @response
    end
  end

  class SettableHTTPSuccessResponse<Net::HTTPResponse
    def body= (xml)
      @xml = xml
    end

    def body
      @xml
    end

    def getResponseClass 
      Net::HTTPResponse::CODE_CLASS_TO_OBJ[@code]
    end
  end

end
