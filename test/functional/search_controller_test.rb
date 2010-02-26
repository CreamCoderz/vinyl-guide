require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  ASWAD_TITLE = 'aswad'

  def setup
    @data_builder = EbayItemDataBuilder.new
  end

  def test_should_search_for_ebay_items
    check_query(:search, :q)
  end

  def test_search_results_are_paginated
    check_search_pagination(:search, :q)
  end

  #TODO: test ASCENDING and DESCENDING orders for all the sort params
  
  def test_sort_by_price
    ebay_item_med, ebay_item_cheap, ebay_item_expensive = @data_builder.to_items(:price=, [10.0, 5.0, 20.0]) {|item| item.title=ASWAD_TITLE}
    [ebay_item_med, ebay_item_cheap, ebay_item_expensive].each{ |item| item.save}
    expected_items = [ebay_item_expensive, ebay_item_med, ebay_item_cheap]
    get :search, :q => ASWAD_TITLE, :sort => 'price', :page => 1
    assert_equal expected_items, assigns(:ebay_items)
  end

  #TODO: test all sortable fields and order desc and ascending

  def test_sort_by_enddate
    oldest = DateTime.civil(2008, 1, 2, 1, 55, 10)
    middle = DateTime.civil(2009, 1, 2, 1, 45, 10)
    newest = DateTime.civil(2009, 1, 2, 1, 55, 10)
    middle_item, newest_item, oldest_item = @data_builder.to_items(:endtime=, [middle, newest, oldest]) {|item| item.title=ASWAD_TITLE}
    [middle_item, newest_item, oldest_item].each{ |item| item.save}
    expected_items = [newest_item, middle_item, oldest_item]
    expected_items.each { |expected_item| expected_item.save}
    get :search, :q => ASWAD_TITLE, :sort => 'endtime', :page => 1
    assert_equal expected_items, assigns(:ebay_items)
  end

  def test_sort_by_title
    ebay_item_linval, ebay_item_esk, ebay_item_sabba = @data_builder.to_items(:title=, ["Linval #{ASWAD_TITLE}", "Eskender #{ASWAD_TITLE}", "Sabba #{ASWAD_TITLE}"])
    [ebay_item_linval, ebay_item_esk, ebay_item_sabba].each{ |item| item.save}
    expected_items = [ebay_item_sabba, ebay_item_linval, ebay_item_esk]
    get :search, :q => ASWAD_TITLE, :sort => 'title', :page => 1
    assert_equal expected_items, assigns(:ebay_items)
  end

  #TODO: it really should return a 400 for a bad sort param, but i'll let it default for now

#  def test_bad_sort_param
#    get :search, :q => ASWAD_TITLE, :sort => 'foobar', :page => 1
#    assert_response 400
#  end

  #TODO: don't die on missing query param
  #TODO: do not bother searching for empty queries

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
