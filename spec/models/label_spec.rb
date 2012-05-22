require 'spec_helper'

describe Label do
  before do
    @valid_attributes = {
            :name => "value for name",
            :description => "value for description"
    }
  end

  describe "create" do
    it "should create a new instance given valid attributes" do
      Label.create!(@valid_attributes)
    end

    it "should trim whitespace around the name" do
      label = Label.create(:name => "  Rockers  ", :description => "Label with whitespace")
      label.name.should == "Rockers"
      label.name = "   Rockers   "
      label.save
      label.name.should == "Rockers"      
    end
  end

  describe "#before_destroy" do
    it "removes associations to releases" do
      label = Factory(:label)
      release = Factory(:release, :label_entity => label)
      label.destroy
      release.reload.label_id.should be_nil
    end
  end

  describe "constraints" do
    it "should validate uniqueness of name" do
      Label.create!(:name => "Studio One")
      Label.create(:name => "Studio One").errors[:name].should include("The label name must be unique.")
      Label.create(:name => "sTuDio oNE").errors[:name].should include("The label name must be unique.")
    end

    it "should delete all references to itself when destroyed" do
      label = Factory(:label, :name => "Studio One")
      release = Factory(:release, :label_entity => label)
      release.label_entity.should_not be_nil
      label.destroy
      release.reload.label_entity.should be_nil
    end
  end

  describe "associations" do
    it "should have many releases" do
      label = Factory(:label)
      release = Factory(:release)
      label.releases = [release]
      label.save
      label.releases.should == [release]
    end
  end

  describe "#ebay_item" do
    before do
      @label = Factory(:label)
    end

    it "should return the first ebay item of the first release" do
      @label.releases = [Factory(:release)]
      @label.ebay_item.should == @label.releases.first.ebay_items.first
    end

    it "should return nil if no release has been mapped" do
      @label.ebay_item.should be_nil
    end
  end
end
