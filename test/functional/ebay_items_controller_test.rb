require 'test_helper'

class EbayItemsControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    ebay_items = EbayItem.find(:all, :order => "endtime").reverse
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 5, actual_ebay_items.length
    assert_equal ebay_items, actual_ebay_items
  end

  def test_should_display_item_details
    item_id = 1
    get :show, :id => item_id.to_param
    assert_response :success
    ebay_item = EbayItem.find(item_id)
    actual_ebay_items = assigns(:ebay_item)
    assert_equal ebay_item, actual_ebay_items
  end
end