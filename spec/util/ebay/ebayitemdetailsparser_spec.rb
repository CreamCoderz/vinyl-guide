require 'time'
require 'spec'
require 'activesupport'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayitemsdetailsparser'

class EbayItemsDetailsParserTest
  describe EbayItemsDetailsParser do

    it "should parse an ebay response for multiple item details" do
      item_detailses = EbayItemsDetailsParser.parse(BaseSpecCase::SAMPLE_GET_MULTIPLE_ITEMS_RESPONSE)
      item_detailses.length.should == 2
      actual_tetrack_item = item_detailses[0]
      actual_garnet_silk_item = item_detailses[1]
      EbayItemsDetailsParserTest.check_ebay_item(actual_tetrack_item, CGI.unescapeHTML(BaseSpecCase::TETRACK_DESCRIPTION),
              BaseSpecCase::TETRACK_ITEMID, Time.iso8601(BaseSpecCase::TETRACK_ENDTIME).to_date, Time.iso8601(BaseSpecCase::TETRACK_STARTTIME).to_date,
              BaseSpecCase::TETRACK_URL, BaseSpecCase::TETRACK_GALLERY_IMG, BaseSpecCase::TETRACK_BIDCOUNT,
              BaseSpecCase::TETRACK_PRICE, BaseSpecCase::TETRACK_SELLERID)
      EbayItemsDetailsParserTest.check_ebay_item(actual_garnet_silk_item, CGI.unescapeHTML(BaseSpecCase::GARNET_DESCRIPTION),
              BaseSpecCase::GARNET_ITEMID, Time.iso8601(BaseSpecCase::GARNET_ENDTIME).to_date, Time.iso8601(BaseSpecCase::GARNET_STARTTIME).to_date,
              BaseSpecCase::GARNET_URL, BaseSpecCase::GARNET_GALLERY_IMG, BaseSpecCase::GARNET_BIDCOUNT,
              BaseSpecCase::GARNET_PRICE, BaseSpecCase::GARNET_SELLERID)
    end

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