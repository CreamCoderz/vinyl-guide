require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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

    response.should have_tag("form[action=#{ebay_item_path(@ebay_item)}][method=post]") do
      with_tag('input#ebay_item_release_id[name=?]', "ebay_item[release_id]")
    end
  end
end
