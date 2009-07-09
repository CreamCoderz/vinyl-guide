require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/../../base_spec_case"

class EbayCrawler

  #TODO: find a way of stubbing EbayCrawler.. do not reuse the SettableHttpClient
  describe "it should send a request to ebay" do
    #TODO: please get rid of the unused initializtion param
    http_client = SettableHttpClient.new "unused"
    http_client.set_response(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_crawler = EbayCrawler.new(WebClient.new(http_client))
    find_items_results = ebay_crawler.find_items


    #TODO: generate the url relative to the current time
    http_client.path.should == '/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&MessageID=the%20message&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae'

  end


  #TODO: test crawling errors
  # url
  # 'http://open.api.ebay.com/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae'
  # puts URI.escape('version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae')


  
end