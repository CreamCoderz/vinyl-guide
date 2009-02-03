require 'net/http'
require 'uri'

class Crawler 

  def initialize(httpClient, url)
    @httpClient = httpClient
    @url = url 
  end

  def crawl
    @uri = URI.parse(@url)
    @response = @httpClient.start(@uri.host, @uri.port) { |http|
      @response = http.get(@uri.path)
    }
  end
end
