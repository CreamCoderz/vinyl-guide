require 'spec'
require 'time'
require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/../../base_spec_case"

describe EbayCrawler do

  it "should crawl ebay for auctions ending within a given future time interval" do
    ebay_client_mock = mock("ebay_client_mock")
    current_time = Time.parse('2009-07-19T10:20:00+00:00')
    ebay_client_mock.should_receive(:get_current_time).with(no_args()).and_return(current_time)
    EbayCrawler::CRAWLING_INTERVAL_SECONDS.should == 20 * 60
    ebay_client_mock.should_receive(:find_items).with(current_time, current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS).and_return(BaseSpecCase::FOUND_ITEMS)
    ebay_crawler = EbayCrawler.new(ebay_client_mock)
    results = ebay_crawler.crawl
    results.should == BaseSpecCase::FOUND_ITEMS
  end

  it "should get item details for known ended auctions" do
    ebay_client_mock = mock("ebay_client_mock")
    item_details_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML)
    ebay_client_mock.should_receive(:get_details).with([BaseSpecCase::TETRACK_ITEMID, BaseSpecCase::GARNET_ITEMID]).and_return(item_details_response)
    ebay_crawler = EbayCrawler.new(ebay_client_mock)
    results = ebay_crawler.get_items([BaseSpecCase::TETRACK_ITEMID, BaseSpecCase::GARNET_ITEMID])
    EbayItemsDetailsParserTest::check_tetrack_item(results[0])
    EbayItemsDetailsParserTest::check_garnet_item(results[1])
  end

end