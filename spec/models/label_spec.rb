require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Label do
  before do
    @valid_attributes = {
            :name => "value for name",
            :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Label.create!(@valid_attributes)
  end

  describe "constraints" do
    it "should validate uniqueness of name" do
      Label.create!(:name => "Studio One")
      Label.create(:name => "Studio One").errors.on(:name).should == "The label name must be unique."    
      Label.create(:name => "sTuDio oNE").errors.on(:name).should == "The label name must be unique."    
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
end
