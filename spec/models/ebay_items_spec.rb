require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/domain/ebayitemdatabuilder'

describe EbayItem do
  ASWAD_TITLE = 'aswad'
  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_FIELDS
  DESC, ASC = SearchController::ORDER_FIELDS

  before :each do
    @data_builder = EbayItemDataBuilder.new
  end

  describe "validations" do

    before do
      @ebay_item = Factory(:ebay_item)
    end

    it "should validate uniquess of itemid" do
      EbayItem.create(:itemid => @ebay_item.itemid).errors.on(:itemid).should_not be_nil
    end
  end

  describe "#link" do
    it "should generate a link" do
      ebay_item = Factory.create(:ebay_item)
      ebay_item.link.should == "/#{ebay_item.id}"
    end
  end
end