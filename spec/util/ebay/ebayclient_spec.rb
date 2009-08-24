require 'spec'
require 'time'
require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/ebayitemdetailsparser_spec'

describe EbayClient do

  #TODO: stub EbayClient.. do not reuse the SettableHttpClient
  it "should send a request to ebay" do
    #TODO: please get rid of the unused initializtion param
    web_client = SettableHttpClient.new "unused"
    web_client.set_response(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_client = EbayClient.new(WebClient.new(web_client))
    end_time_from = Date.new
    end_time_to = Date.new.next
    find_items_results = ebay_client.find_items(end_time_from, end_time_to)
    web_client.path.should == '/shopping?version=517&appid=' + EbayClient::APP_ID +
            '&callname=' + EbayClient::FIND_ITEMS_CALL.to_s + '&CategoryID=306&DescriptionSearch=true' +
            '&EndTimeFrom=' + DateUtil.date_to_utc(end_time_from) + '&EndTimeTo=' + DateUtil.date_to_utc(end_time_to) +
            '&MaxEntries=100' + '&PageNumber=1&QueryKeywords=reggae'
    web_client.host.should == 'open.api.ebay.com'
    find_items_results.should == BaseSpecCase::FOUND_ITEMS
    #TODO: log all other unmarked items
  end

  it "should get details for multiple items" do
    web_client = SettableHttpClient.new "unused"
    multiple_items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML)
    web_client.set_response(multiple_items_response)
    ebay_client = EbayClient.new(WebClient.new(web_client))
    detailses = ebay_client.get_details([BaseSpecCase::TETRACK_ITEMID, BaseSpecCase::GARNET_ITEMID])
    web_client.path.should == BaseSpecCase::SAMPLE_GET_MULTIPLE_ITEMS_REQUEST
    web_client.host.should == 'open.api.ebay.com'
    detailses.length.should == 2
    EbayItemsDetailsParserTest.check_tetrack_item(detailses[0])
    EbayItemsDetailsParserTest.check_garnet_item(detailses[1])
  end

  it "should not exceed 20 items details per request" do
    web_client = mock('web_client')
    expected_ebay_items = []
    response_data = ['', '']
    for i in (1..30)
      ebay_item = EbayItemData.new("description #{i}", i, Time.new, Time.new, "http://www.ebay.com/#{i}}", "http://img.com/#{i}", i, 10.0 + i, "steve#{i}")
      expected_ebay_items.insert(-1, ebay_item)
      if i < 20
        response_data[0] += BaseSpecCase.generate_detail_item_xml_response(ebay_item)
      else
        response_data[1] += BaseSpecCase.generate_detail_item_xml_response(ebay_item)
      end
    end
    response1 = SettableHTTPSuccessResponse.new("1.1", 2, "UNUSED")
    response1.body = EbayItemsDetailsParserTest.make_multiple_items_response(response_data[0])
    response2 = SettableHTTPSuccessResponse.new("1.1", 2, "UNUSED")
    response2.body = EbayItemsDetailsParserTest.make_multiple_items_response(response_data[1])
    web_client.should_receive(:get).ordered.with(BaseSpecCase::SAMPLE_BASE_URL + BaseSpecCase.generate_multiple_items_request(expected_ebay_items[0..19].map{|ebay_item| ebay_item.itemid.to_s})).and_return(response1)
    web_client.should_receive(:get).ordered.with(BaseSpecCase::SAMPLE_BASE_URL + BaseSpecCase.generate_multiple_items_request(expected_ebay_items[20..29].map{|ebay_item| ebay_item.itemid.to_s})).and_return(response2)
    ebay_client = EbayClient.new(web_client)
    actual_details = ebay_client.get_details(expected_ebay_items.map{|ebay_item| ebay_item.itemid})
    actual_details.length.should == expected_ebay_items.length
  end

  it "should get the current ebay time" do
    web_client = SettableHttpClient.new "unused"
    web_client.set_response(BaseSpecCase::SAMPLE_GET_EBAY_TIME_RESPONSE)
    ebay_client = EbayClient.new(WebClient.new(web_client))
    current_time = ebay_client.get_current_time
    web_client.path.should == BaseSpecCase::SAMPLE_GET_EBAY_TIME_REQUEST
    web_client.host.should == 'open.api.ebay.com'
    current_time.should == DateUtil.utc_to_date(BaseSpecCase::CURRENT_EBAY_TIME)
  end

  #TODO: test crawling errors

end