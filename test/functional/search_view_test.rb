require 'test_helper'
include BaseTestCase

class SearchViewTest <  ActionController::TestCase
  PRINCE = 'prince'

  def setup
    @controller = SearchController.new
  end

  def test_should_display_search_view
    expected_records = [records(:two), records(:four)]
    get :search, :query => PRINCE
    assert_response :success
    records = assigns(:records)
    assert_select '.recordItem' do |records|
      count = 0
      records.each do |record|
        assert_select record, 'p span' do |record_fields|
          expected_record = expected_records[count]
          check_record_field [Proc.new {|field, expected_value| assert_equal CGI.escapeHTML(expected_record[expected_value].to_s), field.children.to_s}],
                  record_fields, RECORD_DISPLAY_FIELDS
          count += 1
        end
      end
    end
  end

  def test_should_display_header_data
    get :search, :query => PRINCE
    assert_select 'h3', CGI.escapeHTML('2 Search Results found for "' + PRINCE + '"')
  end

end