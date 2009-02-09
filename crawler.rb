require 'net/http'
require 'uri'
require 'feedparser'

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
    @result = FeedParser.parse(get.body)
  end
end
