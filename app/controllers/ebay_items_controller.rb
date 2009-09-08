class EbayItemsController < ApplicationController
  PAGE_LIMIT = 20

  def index
    @ebay_items = EbayItem.find(:all, :order => "id DESC", :limit => PAGE_LIMIT)
  end

  def show
    @ebay_item = EbayItem.find(params[:id])
  end

  def all
    page_num = params[:id].to_i
    start_index = (page_num - 1) * PAGE_LIMIT
    end_index = start_index + PAGE_LIMIT - 1
    all_ebay_items = EbayItem.find(:all, :order => "id DESC")
    @ebay_items = all_ebay_items[start_index..end_index]
    @prev = (page_num > 1) ? page_num - 1 : nil
    #TODO: find a better way to calculate the next link
    before_end = all_ebay_items.length != end_index + 1
    @next = (before_end && @ebay_items.length >= PAGE_LIMIT) ? page_num + 1 : nil
    @start = start_index + 1
    @end = start_index + @ebay_items.length
    @total = all_ebay_items.length
  end
end