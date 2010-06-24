require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/labels/index.html.erb" do
  include LabelsHelper

  before(:each) do
    assigns[:labels] = [
      stub_model(Label,
        :name => "value for name",
        :description => "value for description"
      ),
      stub_model(Label,
        :name => "value for name",
        :description => "value for description"
      )
    ]
  end

  it "renders a list of labels" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
