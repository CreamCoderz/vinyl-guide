require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def test_should_search_for_records
    get :search, :query => 'lee perry'
    assert_response :success
    records = assigns(:records)
    assert_equal(4, records.length)
  end
end
