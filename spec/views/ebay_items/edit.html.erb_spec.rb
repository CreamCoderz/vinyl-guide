require 'spec_helper'

describe "/ebay_items/edit.html.erb" do
  include EbayItemsHelper

  before(:each) do
    assigns[:ebay_item] = @ebay_item = stub_model(EbayItem,
                                                  :new_record? => false,
                                                  :release_id => 1
    )
  end

  it "renders the edit ebay_item form" do
    render
    response.should have_tag('input#release-finder[name=?]', "q")
  end
end
