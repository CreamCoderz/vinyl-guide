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
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, EbayItem)
  end

  #TODO: refactor out query builder and reuse query values

  def singles
    @ebay_items, @prev, @next, @start, @end, @total = paginate(params[:id].to_i, EbayItem, ["size=? OR size=?", '7"', "Single (7-Inch)"])
  end

  def eps
    @ebay_items, @prev, @next, @start, @end, @total = paginate(params[:id].to_i, EbayItem, ["size=? OR size=?", 'EP, Maxi (10, 12-Inch)', '10"'])
  end

  def lps
    @ebay_items, @prev, @next, @start, @end, @total = paginate(params[:id].to_i, EbayItem, ["size=? OR size=? OR size=?", "LP (12-Inch)", "LP", '12"'])
  end

  def other
    @ebay_items, @prev, @next, @start, @end, @total = paginate(params[:id].to_i, EbayItem, ["size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=?", "LP (12-Inch)", "LP", 'EP, Maxi (10, 12-Inch)', '10"', '7"', "Single (7-Inch)", '12"'])
  end
end