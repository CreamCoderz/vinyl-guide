require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/releases/show.html.erb" do
  include ReleasesHelper
  before(:each) do
    assigns[:release] = @release = stub_model(Release,
                                              :title => "value for title",
                                              :artist => "value for artist",
                                              :year => 1978,
                                              :label_entity => Factory(:label, :name => 'value for label'),
                                              :format => Format::LP,
                                              :matrix_number => "value for matrix_number"
    )
    @ebay_items = [Factory(:ebay_item, :release_id => @release.id), Factory(:ebay_item, :release_id => @release.id)]
    assigns[:page_results] = Paginator::Result.new(:items => @ebay_items)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ artist/)
    response.should have_text(/1978/)
    response.should have_text(/value\ for\ label/)
    response.should have_text(/#{Format::LP.name}/)
    response.should have_text(/value\ for\ matrix_number/)
    @ebay_items.each do |ebay_item|
      response.should have_text(/#{ebay_item.title}/)
    end
  end

end
