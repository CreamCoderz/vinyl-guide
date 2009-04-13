require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/feedparser'

class Crawler 

  def initialize(httpClient, url)
    @httpClient = httpClient
    @url = url 
  end

  def get 
    @uri = URI.parse(@url)
    @response = @httpClient.start(@uri.host, @uri.port) { |http|
      @response = http.get(@uri.path)
    }
  end

  def crawl
    response = get
    if (response != Net::HTTPSuccess)
      raise Exception.new('invalid response for url: ' + @url) 
    end
    @result = FeedParser.parse(response.body)
  end
end
