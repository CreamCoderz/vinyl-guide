require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ebay_items/index.erb" do
  include EbayItemsHelper
  before(:each) do
    @release = stub_model(Release,
                          :title => "value for title",
                          :artist => "value for artist",
                          :year => 1978,
                          :label => "value for label",
                          :matrix_number => "value for matrix_number"
    )
    assigns[:release] = @release
    @ebay_item = stub_model(EbayItem,
                            :price => 25.50,
                            :title => "OG '78 press",
                            :endtime => Date.new
    )
    assigns[:ebay_items] = [@ebay_item]
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ artist/)
    response.should have_text(/1978/)
    response.should have_text(/value\ for\ label/)
    response.should have_text(/value\ for\ matrix_number/)
    response.should have_text(/25\.50/)
    response.should have_text(/OG '78 press/)
  end

end
