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
    all_ebay_items = EbayItem.find(:all, :order => "id DESC")
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, all_ebay_items)
  end
end