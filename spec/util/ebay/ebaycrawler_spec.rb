require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/../../base_spec_case"
require 'time'

class EbayCrawler

  #TODO: stub EbayCrawler.. do not reuse the SettableHttpClient
  describe "it should send a request to ebay" do
    #TODO: please get rid of the unused initializtion param
    http_client = SettableHttpClient.new "unused"
    http_client.set_response(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_crawler = EbayCrawler.new(WebClient.new(http_client))
    end_time_from = Date.new
    end_time_to = Date.new.next
    find_items_results = ebay_crawler.find_items(end_time_from, end_time_to)
    http_client.path.should == '/shopping?version=517&appid=' + APP_ID +
            '&callname=' + CALL_NAME.to_s + '&CategoryID=306&DescriptionSearch=true' +
            '&EndTimeFrom=' + DateUtil.date_to_utc(end_time_from) + '&EndTimeTo=' + DateUtil.date_to_utc(end_time_to) +
            '&MaxEntries=100' + '&PageNumber=1&QueryKeywords=reggae'
    find_items_results.should == BaseSpecCase::FOUND_ITEMS
    #TODO: log all other unmarked items
  end

  describe "it should get details for multiple items" do
      
  end

  #TODO: test crawling errors
  # url
  # 'http://open.api.ebay.com/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae'
  # puts URI.escape('version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae')


  
end