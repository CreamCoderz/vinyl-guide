require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Releases" do

  #TODO: this test isn't overriding the updated_at time.. make it stronger
  it "should order ebay items by descending modified date" do
    recent_update_ebay_item = Factory(:ebay_item)
    recent_update_ebay_item.update_attributes(:updated_at => 1.day.ago)
    ebay_item = Factory(:ebay_item)
    ebay_item.update_attributes(:updated_at => 5.days.ago)
    release = Factory(:release)
    release.ebay_items << recent_update_ebay_item
    release.ebay_items << ebay_item
    release.save
    release.reload.ebay_items.should == [recent_update_ebay_item, ebay_item]
  end

  #TODO: wtf happened to the tests?
end
