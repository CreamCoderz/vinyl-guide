require 'spec'
require File.dirname(__FILE__) + "/ebay_base_spec"
require File.dirname(__FILE__) + '/../../../lib/crawler/ebayfinditemsparser'
include EbayBaseSpec

describe EbayFindItemsParser do

  it "should get some stats from ebay response xml" do
    ebay_item_finder = EbayFindItemsParser.new(SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_num_total_items.should == 5
    ebay_item_finder.get_num_items_marked.should == 5
  end

  it "should find a list of item ids from some ebay response xml" do
    ebay_item_finder = EbayFindItemsParser.new(SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_items.should == [FOUND_ITEM_1, FOUND_ITEM_2, FOUND_ITEM_3, FOUND_ITEM_4, FOUND_ITEM_5]
  end

  it "should find one item id from some ebay response xml" do
    ebay_item_finder = EbayFindItemsParser.new(SINGLE_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_items.length.should == 1
    ebay_item_finder.get_items.should == [FOUND_ITEM_1]
  end

  it "should parse a response with an empty list of results" do
    ebay_item_finder = EbayFindItemsParser.new(EMPTY_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_items.should == []
    ebay_item_finder.get_num_total_items.should == 0
    ebay_item_finder.get_num_items_marked.should == 0
  end

  it "should return a boolean indicating if the requestd page is the last page" do
    ebay_item_finder = EbayFindItemsParser.new(EbayBaseSpec.generate_find_items_response(1, 2))
    ebay_item_finder.last_page.should be_false
    ebay_item_finder = EbayFindItemsParser.new(EbayBaseSpec.generate_find_items_response(2, 2))
    ebay_item_finder.last_page.should be_true
  end
end