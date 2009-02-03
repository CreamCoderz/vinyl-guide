require 'net/http'
require 'uri'
require 'crawler'

describe Crawler do
  it "should make a get request for an rss feed from ebay" do
    @httpClient = SettableHttpClient.new 'unused' 
    @expectedResponse = "<?xml version =\"1.0\">\n" +
			    "<rss version=\"2.0\">\n" +
			   "</rss>\n"+
			  "</xml>"
    @httpClient.response = (@expectedResponse)
    @url = "http://www.example.com/index.html"
    @crawler = Crawler.new(@httpClient, @url)
    @actualResponse = @crawler.crawl
    @actualResponse.getResponseClass.should == Net::HTTPSuccess 
    @actualResponse.body.should == @expectedResponse
    @httpClient.host.should == "www.example.com"
    @httpClient.port.should == 80
    @httpClient.path.should == "/index.html" 
  end

  #TODO: test response failure

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
