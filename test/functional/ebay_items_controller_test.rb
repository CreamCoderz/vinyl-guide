require 'test_helper'

class EbayItemsControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    ebay_items = EbayItem.find(:all)
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 5, actual_ebay_items.length
    assert_equal ebay_items, actual_ebay_items
  end
  
end