require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/feedparser'

class Crawler 

  def initialize(http_client, url)
    @http_client = http_client
    @url = url 
  end

  def get 
    @uri = URI.parse(@url)
    @response = @http_client.start(@uri.host, @uri.port) do |http|
      @response = http.get(@uri.path)
    end
  end

  def crawl
    response = get
    if (response != Net::HTTPSuccess)
      raise Exception.new('invalid response for url: ' + @url) 
    end
    @result = FeedParser.parse(response.body)
  end
end
