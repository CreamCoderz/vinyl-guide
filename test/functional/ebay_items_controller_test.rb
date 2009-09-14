require 'test_helper'

class EbayItemsControllerTest < ActionController::TestCase

  def test_should_get_index
    added_ebay_items = generate_some_ebay_items(40)
    get :index
    assert_response :success
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal added_ebay_items[20..39].reverse, actual_ebay_items
  end

  def test_should_limit_results
    generate_some_ebay_items(25)
    get :index
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
  end

  def test_should_display_item_details
    item_id = 1
    get :show, :id => item_id.to_param
    assert_response :success
    ebay_item = EbayItem.find(item_id)
    actual_ebay_items = assigns(:ebay_item)
    assert_equal ebay_item, actual_ebay_items
  end

  def test_all_base_case
    get :all, :id => 1
    ebay_items = [ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one)]
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 5, actual_ebay_items.length
    assert_equal ebay_items, actual_ebay_items
    prev_link = assigns(:prev)
    next_link = assigns(:next)
    assert prev_link.nil?
    assert next_link.nil?
  end

  def test_should_display_all_paginated
    ebay_items = generate_some_ebay_items(25).reverse
    get :all, :id => 1
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_items[0..19], actual_ebay_items
    assert assigns(:prev).nil?
    assert_equal 2, assigns(:next)
    assert_equal 1, assigns(:start)
    assert_equal 20, assigns(:end)
    assert_equal 30, assigns(:total)
    get :all, :id => 2
    actual_ebay_items = assigns(:ebay_items)
    expected_ebay_items = ebay_items[20..24].insert(-1, ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one))
    assert_equal expected_ebay_items, actual_ebay_items
    assert_equal 1, assigns(:prev)
    assert assigns(:next).nil?
    assert_equal 21, assigns(:start)
    assert_equal 30, assigns(:end)
  end

end