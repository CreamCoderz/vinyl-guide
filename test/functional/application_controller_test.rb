require 'test_helper'

class ApplicationControllerTest < Test::Unit::TestCase

  def setup
    @controller = ApplicationController.new
  end

  def test_paginate
    ebay_items = generate_some_ebay_items(30).reverse
#    ebay_items.insert(-1, ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one))
    actual_ebay_items, prev, nexties, start, endies, total = @controller.paginate(1, ebay_items)

    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_items[0..19], actual_ebay_items
    assert prev.nil?
    assert_equal 2, nexties
    assert_equal 1, start
    assert_equal 20, endies
    assert_equal 30, total

    actual_ebay_items, prev, nexties, start, endies, total = @controller.paginate(2, ebay_items)
    expected_ebay_items = ebay_items[20..29]
    assert_equal expected_ebay_items, actual_ebay_items
    assert_equal 1, prev
    assert nexties.nil?
    assert_equal 21, start
    assert_equal 30, endies

    ebay_items.concat(generate_some_ebay_items(10).reverse)
    actual_ebay_items, prev, nexties, start, endies, total = @controller.paginate(2, ebay_items)
    assert nexties.nil?
    assert_equal 1, prev
    assert_equal 21, start
    assert_equal 40, endies
    assert_equal 40, total
  end

  def test_paginate_with_no_results
    actual_ebay_items, prev, nexties, start, endies, total = @controller.paginate(1, [])
    assert_equal [], actual_ebay_items
    assert prev.nil?
    assert nexties.nil?
    assert start.nil?
    assert endies.nil?
    assert_equal 0, total
  end

end