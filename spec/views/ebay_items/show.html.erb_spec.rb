require 'spec_helper'

describe "/ebay_items/show.html.erb" do

  it "should display other mapped auctions" do
    release = Factory(:release)
    ebay_item = Factory(:ebay_item, :release => release, :hasimage => true)
    related_ebay_item = Factory(:ebay_item, :release => release, :hasimage => true)
    assigns[:ebay_item] = ebay_item
    assigns[:release] = Release.new
    assigns[:related_ebay_items] = [related_ebay_item]
    render
    response.should have_tag ".related-items a[href=?]", "/#{related_ebay_item.id}" 
  end
end