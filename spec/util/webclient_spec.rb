require 'spec'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/../../app/util/webclient'
require File.dirname(__FILE__) + '/feedparser_spec'
require File.dirname(__FILE__) + '/settablehttpclient'

describe WebClient do
  URL = "http://rss.example.com/index.html"

  #TODO: test that the host is being used

  it "should make a get request for a given url" do
    http_client = SettableHttpClient.new 'unused'
    expected_response = "<?xml version =\"1.0\">\n" +
            "<rss version=\"2.0\">\n" +
            "</rss>\n"+
            "</xml>"
    http_client.set_response(expected_response)
    crawler = WebClient.new(http_client)
    actual_response = crawler.get(URL)
    actual_response.should == Net::HTTPSuccess
    actual_response.body.should == expected_response
    http_client.host.should == "rss.example.com"
    http_client.port.should == 80
    http_client.path.should == "/index.html"
  end

  it "should make a get request with query params if they exist" do
    http_client = SettableHttpClient.new 'unused'
    crawler = WebClient.new(http_client)
    url_with_query = '/somepath?query=thequery'
    crawler.get('http://www.example.com' +url_with_query)
    http_client.path.should == url_with_query
  end

  #TODO: the rest of this functionality will soon be dead, current left for purposes of reference
  #
  #
  #
  it "should parse request into an array of records" do
    http_client = SettableHttpClient.new 'unused'
    http_client.set_response(FeedParserSpec::FEED_HEADER + FeedParserSpec::FEED_FOOTER)
    crawler = WebClient.new(http_client)
    response = crawler.get(URL)
    actual_results = crawler.get_auctions(response)
    actual_results.length.should == 0
    http_client.set_response(FeedParserSpec::FEED_WITH_ITEMS)
    response = crawler.get(URL)
    actual_results = crawler.get_auctions(response)
    actual_results.length.should == 2
    FeedParserSpec.check_feed_item(actual_results[0], FeedParserSpec::JAZZBO_RECORD)
    FeedParserSpec.check_feed_item(actual_results[1], FeedParserSpec::CONGOS_RECORD)
  end

  #TODO: test response failure on crawl, it should raise a CrawlerException
  it "should raise an exception upon unsuccesful response" do
    http_client = SettableHttpClient.new 'unused'
    http_client.set_response("", "4")
    crawler = WebClient.new(http_client)
    response = crawler.get(URL)
    response.should == Net::HTTPClientError
    begin
      actual_results = crawler.get_auctions(response)
    rescue Exception => detail
      detail.message.should == "invalid response"
    end
  end


end
