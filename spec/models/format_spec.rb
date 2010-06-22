require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Format do
  before(:each) do
    @valid_attributes = {
            :name => "value for name"
    }
  end

  describe "associations" do
    it "should belong to release" do
      Factory(:release)
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
      Format.create!(@valid_attributes)
    end

    it "should validate uniqueness of name" do
      Format.create!(:name => "EL-P")
      Format.create(:name => "EL-P").errors.on(:name).should == "The name must be unique"
    end
  end
end
