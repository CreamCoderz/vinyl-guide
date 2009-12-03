require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def test_should_search_for_ebay_items
    check_query(:search, :q)
  end

  def test_search_results_are_paginated
    check_search_pagination(:search, :q)
  end

  def check_query(method, query_param)
    expected_query = 'lee perry'
    get method, query_param => expected_query
    assert_response :success
    ebay_items = assigns(:ebay_items)
    assert_equal(3, ebay_items.length)
    assert_equal expected_query, assigns(:query)
  end

  def check_search_pagination(method, query_param)
    ebay_items = generate_some_ebay_items(25).reverse
    get method, query_param => ebay_items[0].title
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_items[0..19], actual_ebay_items
    assert assigns(:prev).nil?
    assert_equal 2, assigns(:next)
    assert_equal 1, assigns(:start)
    assert_equal 20, assigns(:end)
    assert_equal 25, assigns(:total)

    get method, query_param => ebay_items[0].title, :page => 2
    actual_ebay_items = assigns(:ebay_items)
    expected_ebay_items = ebay_items[20..24]
    assert_equal expected_ebay_items, actual_ebay_items
    assert_equal 1, assigns(:prev)
    assert assigns(:next).nil?
    assert_equal 21, assigns(:start)
    assert_equal 25, assigns(:end)
  end

end
