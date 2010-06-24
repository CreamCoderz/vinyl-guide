require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/labels/new.html.erb" do
  include LabelsHelper

  before(:each) do
    assigns[:label] = stub_model(Label,
      :new_record? => true,
      :name => "value for name",
      :description => "value for description"
    )
  end

  it "renders new label form" do
    render

    response.should have_tag("form[action=?][method=post]", labels_path) do
      with_tag("input#label_name[name=?]", "label[name]")
      with_tag("textarea#label_description[name=?]", "label[description]")
    end
  end
end
