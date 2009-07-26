require 'time'
require 'spec'
require 'activesupport'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'

class EbayItemsDetailsParserTest
  describe EbayItemsDetailsParser do

    it "should parse an ebay response for multiple item details" do
      multiple_items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML + BaseSpecCase::GARNET_ITEM_XML)
      item_detailses = EbayItemsDetailsParser.parse(multiple_items_response)
      item_detailses.length.should == 2
      actual_tetrack_item = item_detailses[0]
      actual_garnet_silk_item = item_detailses[1]
      EbayItemsDetailsParserTest::check_tetrack_item(actual_tetrack_item)
      EbayItemsDetailsParserTest::check_garnet_item(actual_garnet_silk_item)
    end

    it "should parse an item from a response with only 1 item" do
      puts 'called'
      multiple_items_response = EbayItemsDetailsParserTest.make_multiple_items_response(BaseSpecCase::TETRACK_ITEM_XML)
      item_detailses = EbayItemsDetailsParser.parse(multiple_items_response)
      item_detailses.length.should == 1
      actual_tetrack_item = item_detailses[0]
      EbayItemsDetailsParserTest::check_tetrack_item(actual_tetrack_item)
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
    EbayItemsDetailsParserTest.check_ebay_item(actual_tetrack_item, CGI.unescapeHTML(BaseSpecCase::TETRACK_DESCRIPTION),
            BaseSpecCase::TETRACK_ITEMID, Time.iso8601(BaseSpecCase::TETRACK_ENDTIME).to_date, Time.iso8601(BaseSpecCase::TETRACK_STARTTIME).to_date,
            BaseSpecCase::TETRACK_URL, BaseSpecCase::TETRACK_GALLERY_IMG, BaseSpecCase::TETRACK_BIDCOUNT,
            BaseSpecCase::TETRACK_PRICE, BaseSpecCase::TETRACK_SELLERID)
  end

  def self.check_garnet_item(actual_garnet_silk_item)
    EbayItemsDetailsParserTest.check_ebay_item(actual_garnet_silk_item, CGI.unescapeHTML(BaseSpecCase::GARNET_DESCRIPTION),
            BaseSpecCase::GARNET_ITEMID, Time.iso8601(BaseSpecCase::GARNET_ENDTIME).to_date, Time.iso8601(BaseSpecCase::GARNET_STARTTIME).to_date,
            BaseSpecCase::GARNET_URL, BaseSpecCase::GARNET_GALLERY_IMG, BaseSpecCase::GARNET_BIDCOUNT,
            BaseSpecCase::GARNET_PRICE, BaseSpecCase::GARNET_SELLERID)
  end

  def self.check_ebay_item(actual_item, description, itemid, endtime, starttime, url, image, bidcount, price, sellerid)
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
end