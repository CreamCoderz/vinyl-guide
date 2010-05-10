require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/releases/show.html.erb" do
  include ReleasesHelper
  before(:each) do
    assigns[:release] = @release = stub_model(Release,
      :title => "value for title",
      :artist => "value for artist",
      :year => 1978,
      :label => "value for label",
      :matrix_number => "value for matrix_number"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ artist/)
    response.should have_text(/1978/)
    response.should have_text(/value\ for\ label/)
    response.should have_text(/value\ for\ matrix_number/)
  end
end
