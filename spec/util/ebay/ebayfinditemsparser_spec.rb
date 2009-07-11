require 'spec'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebayfinditemsparser'

describe EbayFindItemsParser do

  it "should get some stats from ebay response xml" do
    ebay_item_finder = EbayFindItemsParser.new(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_num_total_items.should == 5
    ebay_item_finder.get_num_items_marked.should == 2
    ebay_item_finder.get_num_items_ignored.should == 3
  end

  it "should find a list of item ids from some ebay response xml" do
    ebay_item_finder = EbayFindItemsParser.new(BaseSpecCase::SAMPLE_FIND_ITEMS_RESPONSE)
    ebay_item_finder.get_items.should == BaseSpecCase::FOUND_ITEMS
  end

end