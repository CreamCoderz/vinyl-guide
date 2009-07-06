require 'spec'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/../../app/util/crawler'
require File.dirname(__FILE__) + '/feedparser_spec'

describe Crawler do
  URL = "http://rss.example.com/index.html"
  
  it "should make a get request for a given url" do
    http_client = SettableHttpClient.new 'unused'
    expected_response = "<?xml version =\"1.0\">\n" +
			    "<rss version=\"2.0\">\n" +
			   "</rss>\n"+
			  "</xml>"
    http_client.setResponse(expected_response)
    crawler = Crawler.new(http_client, URL)
    actual_response = crawler.get
    actual_response.should == Net::HTTPSuccess
    actual_response.body.should == expected_response
    http_client.host.should == "rss.example.com"
    http_client.port.should == 80
    http_client.path.should == "/index.html"
  end

  it "should parse request into an array of records" do
    http_client = SettableHttpClient.new 'unused'
    http_client.setResponse(FeedParserSpec::FEED_HEADER + FeedParserSpec::FEED_FOOTER)
    crawler = Crawler.new(http_client, URL)
    actual_results = crawler.crawl
    actual_results.length.should == 0
    http_client.setResponse(FeedParserSpec::FEED_WITH_ITEMS)
    actual_results = crawler.crawl
    actual_results.length.should == 2
    FeedParserSpec.check_feed_item(actual_results[0], FeedParserSpec::JAZZBO_RECORD)
    FeedParserSpec.check_feed_item(actual_results[1], FeedParserSpec::CONGOS_RECORD)
  end
  
  #TODO: test response failure on crawl, it should raise a CrawlerException
  it "should raise an exception upon unsuccesful response" do
    http_client = SettableHttpClient.new 'unused'
    http_client.setResponse("", "4") 
    crawler = Crawler.new(http_client, URL)
    crawler.get.should == Net::HTTPClientError
    begin
      actual_results = crawler.crawl
    rescue Exception => detail
      detail.message.should == "invalid response for url: " + URL  
    end
  end

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

    def setResponse(xml, response_code="2")
      @xml = xml 
      @responseCode = response_code
    end

    def get(path)
      @path = path
      response = SettableHTTPSuccessResponse.new("1.1", @responseCode, "UNUSED")
      response.body = @xml
      response
    end
  end

  class SettableHTTPSuccessResponse<Net::HTTPResponse
    def body= (xml)
      @xml = xml
    end

    def body
      @xml
    end

    def == (another_class)
      Net::HTTPResponse::CODE_CLASS_TO_OBJ[@code] == another_class
    end
  end

end
