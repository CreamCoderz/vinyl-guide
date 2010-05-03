require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/feedparser'

class WebClient

  def initialize(http_client)
    @http_client = http_client
  end

  def get(url)
    uri = URI.parse(url)
    response = @http_client.start(uri.host, uri.port) do |http|
      path = uri.path
      if !uri.query.nil?
        path += "?" + uri.query
      end
      response = http.get(path)
    end
  end

  def crawl(response)
    raise Exception.new('invalid response') if (response != Net::HTTPSuccess)
    @result = FeedParser.parse(response.body)
  end
end
