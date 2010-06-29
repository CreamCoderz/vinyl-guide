require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/releases/index.html.erb" do
  include ReleasesHelper

  before(:each) do
    assigns[:releases] = [
      stub_model(Release,
        :title => "value for title",
        :artist => "value for artist",
        :year => 1978,
        :label_entity => Factory(:label, :name => "value for label"),
        :format => Format::LP,
        :matrix_number => "value for matrix_number"
      ),
      stub_model(Release,
        :title => "value for title",
        :artist => "value for artist",
        :year => 1978,
        :label_entity => Factory(:label, :name => "value for label 2"),
        :format => Format::LP,        
        :matrix_number => "value for matrix_number"
      )
    ]
  end

  it "renders a list of releases" do
    render
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", "value for artist", 2)
    response.should have_tag("tr>td", 1978.to_s, 2)
    response.should have_tag("tr>td", "value for label", 1)
    response.should have_tag("tr>td", Format::LP.name, 2)
    response.should have_tag("tr>td", "value for matrix_number", 2)
  end
end
