require 'spec_helper'

describe "/labels/edit.html.erb" do
  include LabelsHelper

  before(:each) do
    assigns[:label] = @label = stub_model(Label,
      :new_record? => false,
      :name => "value for name",
      :description => "value for description"
    )
  end

  it "renders the edit label form" do
    render

    response.should have_tag("form[action=#{label_path(@label)}][method=post]") do
      with_tag('input#label_name[name=?]', "label[name]")
      with_tag('textarea#label_description[name=?]', "label[description]")
    end
  end
end
