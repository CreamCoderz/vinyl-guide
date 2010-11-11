require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/domain/ebayitemdatabuilder'

describe EbayItem do

  describe "validations" do

    before do
      @ebay_item = Factory(:ebay_item)
    end

    it "should validate uniquess of itemid" do
      EbayItem.create(:itemid => @ebay_item.itemid).errors.on(:itemid).should_not be_nil
    end

  end

  describe ".search" do
    let (:ebay_item) {Factory(:ebay_item)}
    
    it "commits the ebay item to the solr index after creation" do
      EbayItem.search do
        keywords(ebay_item.title)
      end.should_not be_nil
    end

    it "commits the ebay item to the solr index after save" do
      ebay_item.update_attributes(:release_id => 1)
      EbayItem.search do
        keywords(ebay_item.title)
        with(:mapped, true)
      end.should_not be_nil
    end
  end

  describe "#link" do
    it "should generate a link" do
      ebay_item = Factory.create(:ebay_item)
      ebay_item.link.should == "/#{ebay_item.id}"
    end
  end
end