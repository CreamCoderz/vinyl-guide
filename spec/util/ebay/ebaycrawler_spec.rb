require 'spec'
require 'time'
require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/ebayitemdetailsparser_spec'

describe EbayCrawler do

  #TODO: stub EbayCrawler.. do not reuse the SettableHttpClient
  it "should send a request to ebay" do
    #TODO: please get rid of the unused initializtion param
    http_client = SettableHttpClient.new "unused"
    http_client.set_response(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_crawler = EbayCrawler.new(WebClient.new(http_client))
    end_time_from = Date.new
    end_time_to = Date.new.next
    find_items_results = ebay_crawler.find_items(end_time_from, end_time_to)
    http_client.path.should == '/shopping?version=517&appid=' + EbayCrawler::APP_ID +
            '&callname=' + EbayCrawler::FIND_ITEMS_CALL.to_s + '&CategoryID=306&DescriptionSearch=true' +
            '&EndTimeFrom=' + DateUtil.date_to_utc(end_time_from) + '&EndTimeTo=' + DateUtil.date_to_utc(end_time_to) +
            '&MaxEntries=100' + '&PageNumber=1&QueryKeywords=reggae'

    find_items_results.should == BaseSpecCase::FOUND_ITEMS
    #TODO: log all other unmarked items
  end

  it "should get details for multiple items" do
    http_client = SettableHttpClient.new "unused"
    http_client.set_response(BaseSpecCase::SAMPLE_GET_MULTIPLE_ITEMS_RESPONSE)
    ebay_crawler = EbayCrawler.new(WebClient.new(http_client))
    detailses = ebay_crawler.get_details([BaseSpecCase::TETRACK_ITEMID, BaseSpecCase::GARNET_ITEMID])
    http_client.path.should == BaseSpecCase::SAMPLE_GET_MULTIPLE_ITEMS_REQUEST
    detailses.length.should == 2
    #TODO: Duplication is bad.. mmmkay (see EbayItemDetailsParser spec.. soon)
    EbayItemsDetailsParserTest.check_ebay_item(detailses[0], CGI.unescapeHTML(BaseSpecCase::TETRACK_DESCRIPTION),
            BaseSpecCase::TETRACK_ITEMID, Time.iso8601(BaseSpecCase::TETRACK_ENDTIME).to_date, Time.iso8601(BaseSpecCase::TETRACK_STARTTIME).to_date,
            BaseSpecCase::TETRACK_URL, BaseSpecCase::TETRACK_GALLERY_IMG, BaseSpecCase::TETRACK_BIDCOUNT,
            BaseSpecCase::TETRACK_PRICE, BaseSpecCase::TETRACK_SELLERID)
    EbayItemsDetailsParserTest.check_ebay_item(detailses[1], CGI.unescapeHTML(BaseSpecCase::GARNET_DESCRIPTION),
            BaseSpecCase::GARNET_ITEMID, Time.iso8601(BaseSpecCase::GARNET_ENDTIME).to_date, Time.iso8601(BaseSpecCase::GARNET_STARTTIME).to_date,
            BaseSpecCase::GARNET_URL, BaseSpecCase::GARNET_GALLERY_IMG, BaseSpecCase::GARNET_BIDCOUNT,
            BaseSpecCase::GARNET_PRICE, BaseSpecCase::GARNET_SELLERID)
  end

  #TODO: test crawling errors



end