require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/util/paginator'
require File.dirname(__FILE__) + '/../../test/base_test_case'
include BaseTestCase

describe Paginator do

  it "should paginate" do
    #TODO: use ebayitemdatabuilder to generate ebay items
    ebay_items = generate_some_ebay_items(30).reverse
    paginator = Paginator.new(MockActiveRecord.new(ebay_items, :all, {:order => "id DESC", :limit => [1, 20]}))
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(1)

    assert_equal 20, actual_ebay_items.length
    assert_equal ebay_items[0..19], actual_ebay_items
    assert prev.nil?
    assert_equal 2, nexties
    assert_equal 1, start
    assert_equal 20, endies
    assert_equal 30, total

    paginator = Paginator.new(MockActiveRecord.new(ebay_items, :all, {:order => "id DESC", :limit => [21, 40]}))
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(2)
    expected_ebay_items = ebay_items[20..29]
    assert_equal expected_ebay_items, actual_ebay_items
    assert_equal 1, prev
    assert nexties.nil?
    assert_equal 21, start
    assert_equal 30, endies

    ebay_items.concat(generate_some_ebay_items(10).reverse)
    paginator = Paginator.new(MockActiveRecord.new(ebay_items, :all, {:order => "id DESC", :limit => [21, 40]}))
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(2)
    assert nexties.nil?
    assert_equal 1, prev
    assert_equal 21, start
    assert_equal 40, endies
    assert_equal 40, total
  end

  it "should handle no results" do
    paginator = Paginator.new(MockActiveRecord.new([], :all, {:order => "id DESC", :limit => [21, 40]}))
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(1)
    check_empty_results(actual_ebay_items, endies, nexties, prev, start, total)
  end

  it "should handle a page out of range" do
    paginator = Paginator.new(MockActiveRecord.new([], :all))
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(2)
    check_empty_results(actual_ebay_items, endies, nexties, prev, start, total)
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(3)
    check_empty_results(actual_ebay_items, endies, nexties, prev, start, total)
    actual_ebay_items, prev, nexties, start, endies, total = paginator.paginate(0)
    check_empty_results(actual_ebay_items, endies, nexties, prev, start, total)
  end

  def check_empty_results(actual_ebay_items, endies, nexties, prev, start, total)
    assert_equal [], actual_ebay_items
    assert prev.nil?
    assert nexties.nil?
    assert start.nil?
    assert endies.nil?
    assert_equal 0, total
  end

  #TODO: eventually replace this with a mock object. this is an artifact from Test::Unit
  class MockActiveRecord
    def initialize(items, all, expectations=nil)
      @items = items
      @expectations = expectations
      @all = all
    end

    def find(keyword, conditions=nil)
      if @items.empty?
        return []
      end
      if conditions[:offset]
        offset = conditions[:offset]
        end_index = offset-1 + 20 > @items.length ? @items.length : offset-1 + 20
        return @items[(offset)..end_index]
      end
      @items
    end

    def count (keyword, conditions=nil)
      @items.length
    end
  end

end