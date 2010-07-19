require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../db/migrate/20100710232213_remove_duplicate_ebay_items'

describe RemoveDuplicateEbayItems do

  before do
    RemoveDuplicateEbayItems.down
  end
  
  after do
    ActiveRecord::Base.connection.execute("delete from ebay_items;")
  end

  xit "should remove ebay items with duplicate item ids" do
    ebay_item = Factory(:ebay_item, :itemid => 123456)
    ActiveRecord::Base.connection.execute("insert into ebay_items(itemid) values(#{ebay_item.itemid});")
    Factory(:ebay_item)
    RemoveDuplicateEbayItems.up
    EbayItem.find_by_sql("select * from ebay_items").length.should == 2
  end
end