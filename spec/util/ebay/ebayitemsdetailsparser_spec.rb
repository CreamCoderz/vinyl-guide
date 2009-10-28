require 'time'
require 'spec'
require 'activesupport'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + "/ebayitemsdetailsparser_helper"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'
include Spec::Matchers
include EbayItemsDetailsParserHelper

describe EbayItemsDetailsParser do

  it "should parse an ebay response for multiple item details" do
    items_response = make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML)
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    item_detailses.length.should == 2
    actual_tetrack_item = item_detailses[0]
    actual_garnet_silk_item = item_detailses[1]
    check_tetrack_item(actual_tetrack_item)
    check_garnet_item(actual_garnet_silk_item)
  end

  it "should parse an item from a response with only 1 item" do
    no_items_response = make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML)
    item_detailses = EbayItemsDetailsParser.parse(no_items_response)
    item_detailses.length.should == 1
    actual_tetrack_item = item_detailses[0]
    check_tetrack_item(actual_tetrack_item)
  end

  it "should parse a response with no items into an empty list" do
    no_items_response = make_multiple_items_response("")
    item_detailses = EbayItemsDetailsParser.parse(no_items_response)
    item_detailses.length.should == 0
  end

  it "should handle parsing missing gallery image node" do
    expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
            5.00, "steve", "record with missing gallery image", "FR", ['http://blah.com/1', 'http://blah.com/2'], BaseSpecCase::USD_CURRENCY, "12\"", "Roots", "USED", "45 RPM")
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "should handle parsing missing picture image node" do
    expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
            5.00, "steve", "record with missing gallery image", "FR", nil, BaseSpecCase::USD_CURRENCY, "12\"", "Dub", "USED", "45 RPM")
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "sould handle parsing one picture image node" do
    expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
            5.00, "steve", "record with missing gallery image", "FR", ['http://blah.com/1'], BaseSpecCase::USD_CURRENCY, "12\"", "Ska", "USED", "45 RPM")
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "should ignore results with 0 bids" do
    item_with_no_specifics = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 0,
            5.00, "steve", "record with 0 bids", "FR", ['http://blah.com/1', 'http://blah.com/2'], BaseSpecCase::USD_CURRENCY, "12\"", "Dancehall", "USED", "45 RPM")
    items_response = make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML + BaseSpecCase.generate_detail_item_xml_response(item_with_no_specifics))
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    check_ebay_item([BaseSpecCase::TETRACK_EBAY_ITEM, BaseSpecCase::GARNET_EBAY_ITEM], item_detailses)
  end

  it "should handle missing item specifics" do
    item_with_no_specifics = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 1,
            5.00, "steve", "record with bids", "FR", ['http://blah.com/1', 'http://blah.com/2'], BaseSpecCase::USD_CURRENCY)
    item_detail_response = BaseSpecCase.generate_all_detail_item_xml_response(item_with_no_specifics,
            "<ItemSpecifics>
              <NameValueList>
              <Name>Returns Accepted</Name>
              <Value>ReturnsNotAccepted</Value>
              </NameValueList>
            </ItemSpecifics>")
    items_response = make_multiple_items_response(item_detail_response)
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    item_detailses.length.should == 1
    item_detailses[0].should == item_with_no_specifics
  end

  it "should handle nil item specifics" do
    item_with_no_specifics = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 1,
            5.00, "steve", "record with bids", "FR", ['http://blah.com/1', 'http://blah.com/2'], BaseSpecCase::USD_CURRENCY)
    items_response = make_multiple_items_response(BaseSpecCase.generate_all_detail_item_xml_response(item_with_no_specifics))
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    item_detailses.length.should == 1
    item_detailses[0].should == item_with_no_specifics
  end

  it "should handle currency types" do
    expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
            5.00, "steve", "record with missing gallery image", "FR", ['http://blah.com/1'], BaseSpecCase::GBP_CURRENCY, "12\"", "Ska", "USED", "45 RPM")
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end
end