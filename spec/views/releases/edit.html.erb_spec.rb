require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/releases/edit.html.erb" do
  include ReleasesHelper

  before(:each) do
    label = Factory(:label, :name => "value for label")
    assigns[:release] = @release = stub_model(Release,
                                              :new_record? => false,
                                              :title => "value for title",
                                              :artist => "value for artist",
                                              :year => "value for year",
                                              :label_id => label.id,
                                              :matrix_number => "value for matrix_number"
    )
  end

  it "renders the edit release form" do
    render

    response.should have_tag("form[action=#{release_path(@release)}][method=post]") do
      with_tag('input#release_title[name=?]', "release[title]")
      with_tag('input#release_artist[name=?]', "release[artist]")
      with_tag('input#release_year[name=?]', "release[year]")
      with_tag("select#label_selector[name=?]", "release[label_entity_attributes][name]")
      with_tag('select#release_format_id[name=?]', "release[format_id]")
      with_tag('input#release_matrix_number[name=?]', "release[matrix_number]")
    end
  end
end
