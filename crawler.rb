require 'net/http'
require 'uri'

class Crawler 

  def initialize(httpClient)
    @httpClient = httpClient
  end

  def crawl
    @url = URI.parse('http://www.example.com/index.html') 
    @response = @httpClient.start(@url.host, @url.port) { |http|
      @response = http.get(@url.path)
    }
  end
end
