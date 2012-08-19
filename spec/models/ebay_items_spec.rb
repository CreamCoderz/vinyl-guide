require File.dirname(__FILE__) + '/../spec_helper'

describe EbayItem do

  context "validations" do
    before do
      @ebay_item = Factory(:ebay_item)
    end

    it { should validate_uniqueness_of(:itemid) }
    it { should have_many(:comments) }

  end

  context "after create" do
    it "sets the format based on the size" do
      Factory(:ebay_item, :size => '7"').format.should == Format::SINGLE
    end
  end

  context "named scopes" do
    context "formats" do
      before do
        @other_ebay_item = Factory(:ebay_item, :size => "jumbo")
      end
      describe ".all_time" do
        it "scopes items for all" do
          EbayItem.all_time.should == [@other_ebay_item]
        end
      end
      describe ".singles" do
        it "scopes items by the single format" do
          single = Factory(:ebay_item, :size => '7"', :created_at => Time.now)
          single2 = Factory(:ebay_item, :size => "Single (7-Inch)", :created_at => Time.now - 1)
          ebay_item_singles = EbayItem.singles
          ebay_item_singles.should == [single, single2]
        end
      end
      describe ".eps" do
        it "scopes items by the ep format" do
          ep = Factory(:ebay_item, :size => '10"', :created_at => Time.now)
          ep2 = Factory(:ebay_item, :size => "EP, Maxi (10, 12-Inch)", :created_at => Time.now-1)
          ep3 = Factory(:ebay_item, :size => "Single, EP (12-Inch)", :created_at => Time.now-2)
          ebay_item_eps = EbayItem.eps
          ebay_item_eps.should == [ep, ep2, ep3]
        end
      end
      describe ".lps" do
        it "scopes items by the lp format" do
          lp = Factory(:ebay_item, :size => 'LP (12-Inch)', :created_at => Time.now)
          lp2 = Factory(:ebay_item, :size => "LP", :created_at => Time.now - 1)
          lp3 = Factory(:ebay_item, :size => '12"', :created_at => Time.now - 2)
          ebay_item_lps = EbayItem.lps
          ebay_item_lps.should == [lp, lp2, lp3]
        end
      end
      describe ".other" do
        it "scopes items by any other size" do
          Factory(:ebay_item, :size => "LP")
          Factory(:ebay_item, :size => '7"')
          Factory(:ebay_item, :size => '10"')
          ebay_item_lps = EbayItem.other
          ebay_item_lps.should == [@other_ebay_item]
        end
      end
    end
    describe ".today" do
      it "returns all items created today" do
        Factory(:ebay_item, :endtime => 2.days.ago)
        ebay_item = Factory(:ebay_item)
        EbayItem.today.should == [ebay_item]
      end
      it "returns all items created this week" do
        Factory(:ebay_item, :endtime => 8.days.ago)
        ebay_item = Factory(:ebay_item)
        EbayItem.week.should == [ebay_item]
      end
      it "returns all items created this month" do
        Factory(:ebay_item, :endtime => 32.days.ago)
        ebay_item = Factory(:ebay_item)
        EbayItem.month.should == [ebay_item]
      end
    end
    describe ".top_items" do
      before do
        @ebay_items = []
        5.times { |i| @ebay_items << Factory(:ebay_item, :price => 1.00 * i) }
      end
      it "assigns todays top four highest priced items" do
        EbayItem.top_items.should == @ebay_items[1..-1].reverse
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


  describe "#related_items" do
    it "returns empty" do
      Factory(:ebay_item).related_items.should be_empty
    end
    it "returns associated ebay items" do
      release = Factory(:release)
      ebay_item = Factory(:ebay_item, :release => release)
      related_ebay_item = Factory(:ebay_item, :release => release)
      ebay_item.related_items.should == [related_ebay_item]
    end
  end

  describe "#link" do
    it "should generate a link" do
      ebay_item = Factory.create(:ebay_item)
      ebay_item.link.should == "/#{ebay_item.id}"
    end
  end

  describe "#legacy_gallery_path" do
    before do
      @ebay_item = Factory.create(:ebay_item)
    end
    it "returns a path to the image using the ebay_item id" do
      @ebay_item.hasimage = true
      @ebay_item.legacy_gallery_path.should == "/images/gallery/#{@ebay_item.id}.jpg"
    end
    it "returns a path to the default image when hasimage is false" do
      @ebay_item.hasimage = false
      @ebay_item.legacy_gallery_path.should == "/images/noimage.jpg"
    end
  end

end