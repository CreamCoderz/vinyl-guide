require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def test_should_search_for_ebay_items
    expected_query = 'lee perry'
    get :search, :query => expected_query
    assert_response :success
    ebay_items = assigns(:ebay_items)
    assert_equal(4, ebay_items.length)
    assert_equal expected_query, assigns(:query)
  end

  def test_input_is_html_escaped
    html_query = '<font color="red">test</font>'
    get :search, :query => html_query
    actual_query = assigns(:query)
    assert_equal CGI.escapeHTML(html_query), actual_query
  end
end
