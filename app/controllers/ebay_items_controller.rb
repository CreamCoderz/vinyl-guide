class EbayItemsController < ApplicationController

  def index
    @ebay_items = EbayItem.find(:all)  
  end

end