require 'test_helper'
include BaseTestCase

class SearchViewTest <  ActionController::TestCase

  def setup
    @controller = SearchController.new
  end

  def test_should_display_search_view
    expected_records = [records(:two), records(:four)]
    get :search, :query => 'prince'
    assert_response :success
    records = assigns(:records)
    assert_select '.recordItem' do |record|
      count = 0
      record.each do |something2|
        assert_select something2, 'p span' do |record_fields|
          puts record_fields
          puts count
          expected_record = expected_records[count]
          puts expected_record
          check_record_field [Proc.new {|field, expected_value| assert_equal CGI.escapeHTML(expected_record[expected_value].to_s), field.children.to_s}],
                  record_fields, RECORD_DISPLAY_FIELDS
          count += 1
        end
      end
    end
  end
  
end