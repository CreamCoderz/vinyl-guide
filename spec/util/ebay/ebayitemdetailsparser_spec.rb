require 'time'
require 'spec'
require 'activesupport'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'
include Spec::Matchers

class EbayItemsDetailsParserTest
  describe EbayItemsDetailsParser do

    it "should parse an ebay response for multiple item details" do
      items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML)
      item_detailses = EbayItemsDetailsParser.parse(items_response)
      item_detailses.length.should == 2
      actual_tetrack_item = item_detailses[0]
      actual_garnet_silk_item = item_detailses[1]
      EbayItemsDetailsParserTest::check_tetrack_item(actual_tetrack_item)
      EbayItemsDetailsParserTest::check_garnet_item(actual_garnet_silk_item)
    end

    it "should parse an item from a response with only 1 item" do
      no_items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML)
      item_detailses = EbayItemsDetailsParser.parse(no_items_response)
      item_detailses.length.should == 1
      actual_tetrack_item = item_detailses[0]
      EbayItemsDetailsParserTest::check_tetrack_item(actual_tetrack_item)
    end

    it "should parse a response with no items into an empty list" do
      no_items_response = EbayItemsDetailsParserTest.make_multiple_items_response("")
      item_detailses = EbayItemsDetailsParser.parse(no_items_response)
      item_detailses.length.should == 0
    end

    it "should handle parsing missing gallery image node" do
      expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
              5.00, "steve", "record with missing gallery image", ['http://blah.com/1', 'http://blah.com/2'])
      item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
      item_detailses = EbayItemsDetailsParser.parse(EbayItemsDetailsParserTest.make_multiple_items_response(item_detail_response))
      EbayItemsDetailsParserTest.check_ebay_item(expected_item_data, item_detailses[0])
    end

    it "should handle parsing missing picture image node" do
      expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
              5.00, "steve", "record with missing gallery image", nil)
      item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
      item_detailses = EbayItemsDetailsParser.parse(EbayItemsDetailsParserTest.make_multiple_items_response(item_detail_response))
      EbayItemsDetailsParserTest.check_ebay_item(expected_item_data, item_detailses[0])
    end

    it "sould handle parsing one picture image node" do
      expected_item_data = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 10,
              5.00, "steve", "record with missing gallery image", ['http://blah.com/1'])
      item_detail_response = BaseSpecCase.generate_detail_item_xml_response(expected_item_data)
      item_detailses = EbayItemsDetailsParser.parse(EbayItemsDetailsParserTest.make_multiple_items_response(item_detail_response))
      EbayItemsDetailsParserTest.check_ebay_item(expected_item_data, item_detailses[0])
    end

    it "should ignore results with 0 bids" do
      zero_bid_item = EbayItemData.new("desc", 123435, DateTime.parse('2009-08-21T10:20:00+00:00'), DateTime.parse('2009-08-21T10:20:00+00:00'), "http://ebay.com/121", nil, 0,
              5.00, "steve", "record with 0 bids", ['http://blah.com/1', 'http://blah.com/2'])
      items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML + BaseSpecCase.generate_detail_item_xml_response(zero_bid_item))
      item_detailses = EbayItemsDetailsParser.parse(items_response)
      EbayItemsDetailsParserTest.check_ebay_item([BaseSpecCase::TETRACK_EBAY_ITEM, BaseSpecCase::GARNET_EBAY_ITEM], item_detailses)
    end

  end

  def self.make_multiple_items_response(items_xml)
    '<?xml version="1.0" encoding="UTF-8"?>
  <GetMultipleItemsResponse xmlns="urn:ebay:apis:eBLBaseComponents">
    <Timestamp>2009-07-03T23:44:00.302Z</Timestamp>
    <Ack>Success</Ack>
    <Build>e623__Bundled_9520957_R1</Build>
    <Version>623</Version>
    <CorrelationID>get multiple items</CorrelationID>' +
            items_xml +
            '</GetMultipleItemsResponse>'
  end

  def self.check_tetrack_item(actual_tetrack_item)
    EbayItemsDetailsParserTest.check_ebay_item(BaseSpecCase::TETRACK_EBAY_ITEM, actual_tetrack_item)
  end

  def self.check_garnet_item(actual_garnet_silk_item)
    EbayItemsDetailsParserTest.check_ebay_item(BaseSpecCase::GARNET_EBAY_ITEM, actual_garnet_silk_item)
  end

  def self.check_ebay_item_data(actual_item, description, itemid, endtime, starttime, url, image, bidcount, price, sellerid)
    actual_item.description.should == description
    actual_item.itemid.should == itemid
    actual_item.endtime.should == endtime
    actual_item.starttime.should == starttime
    actual_item.url.should == url
    actual_item.galleryimg.should == image
    actual_item.bidcount.should == bidcount
    actual_item.price.should == price
    actual_item.sellerid.should == sellerid
  end

  def self.check_ebay_item(expected_item, actual_item)
    expected_item.should == actual_item
  end
end