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

end