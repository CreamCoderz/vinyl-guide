require 'spec_helper'

describe Format do
  describe "associations" do
    it "has many releases" do
      release = Factory(:release, :format => Format::LP)
      Format::LP.releases.should =~ [release]
    end
    it "has many ebay_items" do
      ebay_item = Factory(:ebay_item, :format => Format::LP)
      Format::LP.reload.ebay_items.should =~ [ebay_item]
    end
  end

  describe "constants" do
    it "should have a constant for LP" do
      Format::LP.name.should == "LP"
    end
    it "should have a constant for EP" do
      Format::EP.name.should == "EP"
    end
    it "should have a constant for Single" do
      Format::SINGLE.name.should == "Single"
    end
  end

  describe "create" do
    it "should create a new instance given valid attributes" do
      Format.create!(:name => "value for name")
    end

    it "should validate uniqueness of name" do
      Format.create!(:name => "EL-P")
      Format.create(:name => "EL-P").errors.on(:name).should == "The name must be unique"
    end
  end
end
