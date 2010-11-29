require File.dirname(__FILE__) + '/../spec_helper'

describe EbayItem do

  context "validations" do

    before do
      @ebay_item = Factory(:ebay_item)
    end

    it "should validate uniquess of itemid" do
      EbayItem.create(:itemid => @ebay_item.itemid).errors.on(:itemid).should_not be_nil
    end

  end

  context "named scopes" do
    before do
      @other_ebay_item = Factory(:ebay_item, :size => "jumbo")
    end
    describe ".singles" do
      it "scopes items by the single format" do
        single = Factory(:ebay_item, :size => '7"')
        single2 = Factory(:ebay_item, :size => "Single (7-Inch)")
        ebay_item_singles = EbayItem.singles
        ebay_item_singles.should =~ [single, single2]
      end
    end
    describe ".eps" do
      it "scopes items by the ep format" do
        ep = Factory(:ebay_item, :size => '10"')
        ep2 = Factory(:ebay_item, :size => "EP, Maxi (10, 12-Inch)")
        ebay_item_eps = EbayItem.eps
        ebay_item_eps.should =~ [ep, ep2]
      end
    end
    describe ".lps" do
      it "scopes items by the lp format" do
        lp = Factory(:ebay_item, :size => 'LP (12-Inch)')
        lp2 = Factory(:ebay_item, :size => "LP")
        lp3 = Factory(:ebay_item, :size => '12"')
        ebay_item_lps = EbayItem.lps
        ebay_item_lps.should =~ [lp, lp2, lp3]
      end
    end
    describe ".other" do
     it "scopes items by any other size" do
        Factory(:ebay_item, :size => "LP")
        Factory(:ebay_item, :size => '7"')
        Factory(:ebay_item, :size => '10"')
        ebay_item_lps = EbayItem.other
        ebay_item_lps.should =~ [@other_ebay_item]
      end
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