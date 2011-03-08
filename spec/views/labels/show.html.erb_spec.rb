require 'spec_helper'

describe "/labels/show.html.erb" do
  include LabelsHelper
  before(:each) do
    assigns[:label] = @label = stub_model(Label,
      :name => "value for name",
      :description => "value for description"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
  end
end
