require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/feed_parser'

class WebClient

  cattr_accessor :client

  def self.get(url)
    uri = URI.parse(url)
    client.start(uri.host, uri.port) do |http|
      path = uri.path
      path += "?" + uri.query if uri.query.present?
      http.get(path)
    end
  end

  def self.crawl(response)
    raise Exception.new('invalid response') if (response != Net::HTTPSuccess)
    @result = FeedParser.parse(response.body)
  end
end
