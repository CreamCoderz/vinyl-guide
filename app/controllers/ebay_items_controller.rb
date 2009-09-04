class EbayItemsController < ApplicationController

  def index
    @ebay_items = EbayItem.find(:all, :order => "endtime").reverse  
  end

  def show
    @ebay_item = EbayItem.find(params[:id])
  end

end