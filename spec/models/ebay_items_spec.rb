require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/domain/ebayitemdatabuilder'

describe EbayItem do
  ASWAD_TITLE = 'aswad'
  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_FIELDS
  DESC, ASC = SearchController::ORDER_FIELDS

  before :each do
    @data_builder = EbayItemDataBuilder.new
  end

  it "should sort by price" do
    ebay_item_med, ebay_item_cheap, ebay_item_expensive = @data_builder.to_items(:price=, * [10.0, 5.0, 20.0]) { |item| item.title=ASWAD_TITLE }
    [ebay_item_med, ebay_item_cheap, ebay_item_expensive].each { |item| item.save }
    expected_items = [ebay_item_expensive, ebay_item_med, ebay_item_cheap]

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :price)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :price, :page => 1, :order => DESC)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :price, :page => 1, :order => ASC)[0]
    search_results.should == expected_items.reverse
  end

  it "should sort by enddate" do
    oldest = DateTime.civil(2008, 1, 2, 1, 55, 10)
    middle = DateTime.civil(2009, 1, 2, 1, 45, 10)
    newest = DateTime.civil(2009, 1, 2, 1, 55, 10)
    middle_item, newest_item, oldest_item = @data_builder.to_items(:endtime=, * [middle, newest, oldest]) { |item| item.title=ASWAD_TITLE }
    [middle_item, newest_item, oldest_item].each { |item| item.save }
    expected_items = [newest_item, middle_item, oldest_item]
    expected_items.each { |expected_item| expected_item.save }
    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :endtime)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :endtime, :page => 1, :order => DESC)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :endtime, :page => 1, :order => ASC)[0]
    search_results.should == expected_items.reverse
  end

  it "should sort alphabetically" do
    ebay_item_linval, ebay_item_esk, ebay_item_sabba = @data_builder.to_items(:title=, * ["Linval #{ASWAD_TITLE}", "Eskender #{ASWAD_TITLE}", "Sabba #{ASWAD_TITLE}"])
    [ebay_item_linval, ebay_item_esk, ebay_item_sabba].each { |item| item.save }
    expected_items = [ebay_item_sabba, ebay_item_linval, ebay_item_esk]
    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :title)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :title, :page => 1, :order => DESC)[0]
    search_results.should == expected_items

    search_results = EbayItem.search(:query => ASWAD_TITLE, :column => :title, :page => 1, :order => ASC)[0]
    search_results.should == expected_items.reverse
  end
end