require 'time'
require 'spec'
require 'activesupport'
require File.dirname(__FILE__) + "/ebay_base_spec"
require File.dirname(__FILE__) + "/ebayitemsdetailsparser_helper"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'
include Spec::Matchers
include EbayItemsDetailsParserHelper
include BaseSpecCase

describe EbayItemsDetailsParser do

  before do
    @data_builder = EbayItemDataBuilder.new
    @ebay_item = @data_builder.make
  end

  it "should parse an ebay response for multiple item details" do
    items_response = make_multiple_items_response(TETRACK_ITEM_XML + GARNET_ITEM_XML)
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    item_detailses.length.should == 2
    actual_tetrack_item = item_detailses[0]
    actual_garnet_silk_item = item_detailses[1]
    check_tetrack_item(actual_tetrack_item)
    check_garnet_item(actual_garnet_silk_item)
  end

  it "should parse an item from a response with only 1 item" do
    no_items_response = make_multiple_items_response(TETRACK_ITEM_XML)
    item_detailses = EbayItemsDetailsParser.parse(no_items_response)
    item_detailses.length.should == 1
    actual_tetrack_item = item_detailses[0]
    check_tetrack_item(actual_tetrack_item)
  end

  it "should html escape title and description fields" do
    @ebay_item.description = "unescape&quot;d description"
    @ebay_item.title = "the unescape&apos;d title"
    expected_item_data = @ebay_item.to_data
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))

    @ebay_item.description = "unescape\"d description"
    @ebay_item.title = "the unescape'd title"
    check_ebay_item(@ebay_item.to_data, item_detailses[0])
  end

  it "should parse a response with no items into an empty list" do
    no_items_response = make_multiple_items_response("")
    item_detailses = EbayItemsDetailsParser.parse(no_items_response)
    item_detailses.length.should == 0
  end

  it "should handle parsing missing gallery image node" do
    @ebay_item.galleryimg = nil
    expected_item_data = @ebay_item.to_data
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "should handle parsing missing picture image node" do
    @ebay_item.pictureimgs = nil
    expected_item_data = @ebay_item.to_data
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "sould handle parsing one picture image node" do
    @ebay_item.pictureimgs = ['http://blah.com/1']
    expected_item_data = @ebay_item.to_data
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end

  it "should ignore results with 0 bids" do
    @ebay_item.bidcount = 0
    expected_item_data = @ebay_item.to_data
    items_response = make_multiple_items_response(TETRACK_ITEM_XML + GARNET_ITEM_XML + BaseSpecCase.generate_detail_item_xml_response(expected_item_data))
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    check_ebay_item([TETRACK_EBAY_ITEM, GARNET_EBAY_ITEM], item_detailses)
  end

  it "should handle missing item specifics" do
    @ebay_item.without_specifics
    item_with_no_specifics = @ebay_item.to_data
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
    @ebay_item.without_specifics
    item_with_no_specifics = @ebay_item.to_data
    items_response = make_multiple_items_response(BaseSpecCase.generate_all_detail_item_xml_response(item_with_no_specifics))
    item_detailses = EbayItemsDetailsParser.parse(items_response)
    item_detailses.length.should == 1
    item_detailses[0].should == item_with_no_specifics
  end

  it "should handle currency types" do
    @ebay_item.currencytype = "FR"
    expected_item_data = @ebay_item.to_data
    item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
    item_detailses = EbayItemsDetailsParser.parse(make_multiple_items_response(item_detail_response))
    check_ebay_item(expected_item_data, item_detailses[0])
  end
end