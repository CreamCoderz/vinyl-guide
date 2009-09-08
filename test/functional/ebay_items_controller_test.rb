require 'test_helper'

class EbayItemsControllerTest < ActionController::TestCase

  def self.generate_some_ebay_items(num)
    ebay_items = []
    (1..num).each do |i|
      ebay_item = EbayItem.new(:itemid => BaseSpecCase::TETRACK_EBAY_ITEM.itemid + i, :title => BaseSpecCase::TETRACK_EBAY_ITEM.title, :description => CGI.unescapeHTML(BaseSpecCase::TETRACK_EBAY_ITEM.description), :bidcount => BaseSpecCase::TETRACK_EBAY_ITEM.bidcount,
              :price => BaseSpecCase::TETRACK_EBAY_ITEM.price, :endtime => BaseSpecCase::TETRACK_EBAY_ITEM.endtime, :starttime => BaseSpecCase::TETRACK_EBAY_ITEM.starttime,
              :url => BaseSpecCase::TETRACK_EBAY_ITEM.url, :galleryimg => BaseSpecCase::TETRACK_EBAY_ITEM.galleryimg, :sellerid => BaseSpecCase::TETRACK_EBAY_ITEM.sellerid)
      ebay_items.insert(-1, ebay_item)
      ebay_item.save
    end
    ebay_items
  end

  def test_should_get_index
    added_ebay_items = EbayItemsControllerTest.generate_some_ebay_items(40)
    get :index
    assert_response :success
    actual_ebay_items = assigns(:ebay_items)
    assert_equal 20, actual_ebay_items.length
    assert_equal added_ebay_items[20..39].reverse, actual_ebay_items
  end

  def test_should_limit_results
    EbayItemsControllerTest.generate_some_ebay_items(25)
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
    ebay_items = EbayItemsControllerTest.generate_some_ebay_items(25).reverse
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
    assert_equal ebay_items[20..24].insert(-1, ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one)), actual_ebay_items
    assert_equal 1, assigns(:prev)
    assert assigns(:next).nil?
    assert_equal 21, assigns(:start)
    assert_equal 30, assigns(:end)
    EbayItemsControllerTest.generate_some_ebay_items(10)
    get :all, :id => 2
    assert assigns(:next).nil?
    assert_equal 1, assigns(:prev)
    assert_equal 21, assigns(:start)
    assert_equal 40, assigns(:end)
    assert_equal 40, assigns(:total)
  end

end