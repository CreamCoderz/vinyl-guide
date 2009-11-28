require 'spec'
require 'time'
require File.dirname(__FILE__) + '/../../../app/util/webclient'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../settablehttpclient'
require File.dirname(__FILE__) + "/ebay_base_spec"
require File.dirname(__FILE__) + "/ebay_base_data"
require File.dirname(__FILE__) + '/ebayitemsdetailsparser_spec'
require File.dirname(__FILE__) + '/ebayitemsdetailsparser_helper'
include EbayItemsDetailsParserHelper
include EbayBaseData
include BaseSpecCase

describe EbayClient do

  before do
    @data_builder = EbayItemDataBuilder.new
  end

  it "should send a find items request to ebay" do
    web_client = SettableHttpClient.new("unused")
    web_client.set_response(SAMPLE_FIND_ITEMS_RESPONSE)
    web_client.set_response(BaseSpecCase.generate_find_items_response_uk(1, 1))
    ebay_client = EbayClient.new(WebClient.new(web_client))
    end_time_to = Date.new.next
    find_items_results = ebay_client.find_items(end_time_to)
    #TODO: these should be in reverse order
    web_client.path[1].should == BaseSpecCase.generate_find_items_request(end_time_to, 1)
    web_client.path[0].should == BaseSpecCase.generate_find_items_request(end_time_to, 1, 'EBAY-GB', 'Reggae%2F+Ska')
    web_client.host.should == SAMPLE_BASE_FIND_HOST
    find_items_results.should == FOUND_ITEMS.concat([FOUND_ITEM_6, FOUND_ITEM_7])
    #TODO: log all other unmarked items
  end

  it "should send request per page for many pages of find items results" do
    web_client = mock('web_client')
    end_time_to = Date.new.next
    uk_request = BaseSpecCase.generate_find_items_request(end_time_to, 1, 'EBAY-GB', 'Reggae%2F+Ska')
    expected_url1 = BaseSpecCase.generate_find_items_request(end_time_to, 1)
    expected_url2 = BaseSpecCase.generate_find_items_request(end_time_to, 2)
    uk_response = BaseSpecCase.make_success_response(BaseSpecCase.generate_complete_find_items_response(1, 1))
    response1 = BaseSpecCase.make_success_response(BaseSpecCase.generate_find_items_response(1, 2))
    response2 = BaseSpecCase.make_success_response(BaseSpecCase.generate_find_items_response(2, 2))
    web_client.should_receive(:get).ordered.with(SAMPLE_BASE_FIND_URL + uk_request).and_return(uk_response)
    web_client.should_receive(:get).ordered.with(SAMPLE_BASE_FIND_URL + expected_url1).and_return(response1)
    web_client.should_receive(:get).ordered.with(SAMPLE_BASE_FIND_URL + expected_url2).and_return(response2)
    ebay_client = EbayClient.new(web_client)
    find_items_results = ebay_client.find_items(end_time_to)
    find_items_results.length.should == 10
  end

  it "should get details for multiple items" do
    web_client = SettableHttpClient.new "unused"
    multiple_items_response = make_multiple_items_response(TETRACK_ITEM_XML + GARNET_ITEM_XML)
    web_client.set_response(multiple_items_response)
    ebay_client = EbayClient.new(WebClient.new(web_client))
    detailses = ebay_client.get_details([TETRACK_ITEMID, GARNET_ITEMID])
    web_client.path[0].should == SAMPLE_GET_MULTIPLE_ITEMS_REQUEST
    web_client.host.should == 'open.api.ebay.com'
    detailses.length.should == 2
    check_tetrack_item(detailses[0])
    check_garnet_item(detailses[1])
  end

  it "should not exceed 20 items details per request" do
    web_client = mock('web_client')
    expected_ebay_items = []
    response_data = ['', '']
    for i in (1..30)
      ebay_item = @data_builder.make.to_data
      expected_ebay_items.insert(-1, ebay_item)
      if i < 20
        response_data[0] += BaseSpecCase.generate_detail_item_xml_response(ebay_item)
      else
        response_data[1] += BaseSpecCase.generate_detail_item_xml_response(ebay_item)
      end
    end
    response1 = BaseSpecCase.make_success_response(make_multiple_items_response(response_data[0]))
    response2 = BaseSpecCase.make_success_response(make_multiple_items_response(response_data[1]))
    web_client.should_receive(:get).ordered.with(SAMPLE_BASE_URL + BaseSpecCase.generate_multiple_items_request(expected_ebay_items[0..19].map{|ebay_item| ebay_item.itemid.to_s})).and_return(response1)
    web_client.should_receive(:get).ordered.with(SAMPLE_BASE_URL + BaseSpecCase.generate_multiple_items_request(expected_ebay_items[20..29].map{|ebay_item| ebay_item.itemid.to_s})).and_return(response2)
    ebay_client = EbayClient.new(web_client)
    actual_details = ebay_client.get_details(expected_ebay_items.map{|ebay_item| ebay_item.itemid})
    actual_details.length.should == expected_ebay_items.length
  end

  it "should get the current ebay time" do
    web_client = SettableHttpClient.new "unused"
    web_client.set_response(SAMPLE_GET_EBAY_TIME_RESPONSE)
    ebay_client = EbayClient.new(WebClient.new(web_client))
    current_time = ebay_client.get_current_time
    web_client.path[0].should == SAMPLE_GET_EBAY_TIME_REQUEST
    web_client.host.should == 'open.api.ebay.com'
    current_time.should == DateUtil.utc_to_date(CURRENT_EBAY_TIME)
  end

  #TODO: test crawling errors

end