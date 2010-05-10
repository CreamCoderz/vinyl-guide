require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/releases/index.html.erb" do
  include ReleasesHelper

  before(:each) do
    assigns[:releases] = [
      stub_model(Release,
        :title => "value for title",
        :artist => "value for artist",
        :year => 1978,
        :label => "value for label",
        :matrix_number => "value for matrix_number"
      ),
      stub_model(Release,
        :title => "value for title",
        :artist => "value for artist",
        :year => 1978,
        :label => "value for label",
        :matrix_number => "value for matrix_number"
      )
    ]
  end

  it "renders a list of releases" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for artist".to_s, 2)
    response.should have_tag("tr>td", 1978.to_s, 2)
    response.should have_tag("tr>td", "value for label".to_s, 2)
    response.should have_tag("tr>td", "value for matrix_number".to_s, 2)
  end
end
