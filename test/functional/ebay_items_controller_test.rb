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
    check_pagination(nil, 2, 1, 20, 30)
    get :all, :id => 2
    actual_ebay_items = assigns(:ebay_items)
    expected_ebay_items = ebay_items[20..24].insert(-1, ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one))
    assert_equal expected_ebay_items, actual_ebay_items
    check_pagination(1, nil, 21, 30, 30)
  end

  def test_all_records_by_size
    ebay_single_1 = generate_ebay_items_with_size(1, "7\"")[0]
    ebay_single_2 = generate_ebay_items_with_size(1, "Single (7-Inch)")[0]
    ebay_ep_1 =  generate_ebay_items_with_size(1, "EP, Maxi (10, 12-Inch)")[0]
    ebay_ep_2 = generate_ebay_items_with_size(1, "10\"")[0]
    ebay_lp_1 = generate_ebay_items_with_size(1, "LP (12-Inch)")[0]
    ebay_lp_2 = generate_ebay_items_with_size(1, '12"')[0]
    other = generate_ebay_items_with_size(1, 'OTHER')[0]
    save_ebay_items([ebay_single_1, ebay_single_2, ebay_ep_1, ebay_ep_2, ebay_lp_1, ebay_lp_2, other])
    get :singles, :id => 1
    assert_equal [ebay_single_2, ebay_single_1], assigns(:ebay_items)
    get :eps, :id => 1
    assert_equal [ebay_ep_2, ebay_ep_1], assigns(:ebay_items)
    get :lps, :id => 1
    assert_equal [ebay_lp_2, ebay_lp_1], assigns(:ebay_items)
    get :other, :id => 1
    assert_equal [other], assigns(:ebay_items)
  end

  def test_all_records_by_size_pagination
    more_than_a_page = 25
    ebay_singles = generate_ebay_items_with_size(more_than_a_page, "7\"")
    ebay_eps =  generate_ebay_items_with_size(more_than_a_page, "10\"")
    ebay_lps = generate_ebay_items_with_size(more_than_a_page, "LP")
    other_items = generate_ebay_items_with_size(more_than_a_page, "Other")
    ebay_singles.map{|ebay_item| ebay_item.save }
    ebay_eps.map{|ebay_item| ebay_item.save }
    ebay_lps.map{|ebay_item| ebay_item.save }
    other_items.map{|ebay_item| ebay_item.save }
    get :singles, :id => 1
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_singles.reverse[0..19], actual_ebay_items
    check_pagination(nil, 2, 1, 20, ebay_singles.length)
    get :eps, :id => 1
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_eps.reverse[0..19], actual_ebay_items
    check_pagination(nil, 2, 1, 20, ebay_eps.length)
    get :lps, :id => 1
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_lps.reverse[0..19], actual_ebay_items
    check_pagination(nil, 2, 1, 20, ebay_lps.length)
    get :other, :id => 1
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal other_items.reverse[0..19], actual_ebay_items
    check_pagination(nil, 2, 1, 20, other_items.length)
  end

  def check_pagination(prev_page, next_page, start_num, end_num, total)
    assert_equal prev_page, assigns(:prev)
    assert_equal next_page, assigns(:next)
    assert_equal start_num, assigns(:start)
    assert_equal end_num, assigns(:end)
    assert_equal total, assigns(:total)
  end
end