require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Labels" do

  describe "associations" do
    it "should have many releases" do
      label = Factory(:label)
      label.releases << release = Factory(:release)
      label.save
      label.releases.should == [release]
    end
  end
end
