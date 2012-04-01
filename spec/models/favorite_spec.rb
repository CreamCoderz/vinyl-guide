require 'spec_helper'

describe Favorite do
  context "associations" do
    it { should belong_to :user }
    it { should belong_to :ebay_item }
  end

  context "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :ebay_item }
  end

  context "scopes" do
    describe ".for_ebay_items" do
      before do
        @favorite = Factory(:favorite)
        Factory(:favorite)
      end
      it "groups favorites by the ebay_item_id" do
        Favorite.for_ebay_items([@favorite.ebay_item]).should == [@favorite]
      end
    end
  end

end