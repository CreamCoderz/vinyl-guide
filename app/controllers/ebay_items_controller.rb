require File.expand_path(File.dirname(__FILE__) + "/parsers/params_parser")

class EbayItemsController < ApplicationController
  PAGE_LIMIT = 20

  def index
    @release = Release.find(params[:release_id])
    @ebay_items = @release.ebay_items.find(:all)
  end

  def edit
    @ebay_item = EbayItem.find(params[:id])
  end

  def update
    @ebay_item = EbayItem.find(params[:id])

    respond_to do |format|
      if @ebay_item.update_attributes(params[:ebay_item])
        flash[:notice] = 'EbayItem was successfully updated.'
        format.html { redirect_to(@ebay_item) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @ebay_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def home
    order_query = set_sortable_fields
    @ebay_items = EbayItem.find(:all, :order => order_query, :limit => PAGE_LIMIT)
  end

  def show
    @ebay_item = EbayItem.find(params[:id])
  end

  def all
    order_query = set_sortable_fields
    @page_num = ParamsParser.parse_page_param(params)
    @sortable_base_url = "/all"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(@page_num, EbayItem, nil, order_query)
  end

  #TODO: move the query building to the model

  def singles
    order_query = set_sortable_fields
    @page_num = ParamsParser.parse_page_param(params)
    @sortable_base_url = "/singles"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(@page_num, EbayItem, ["size=? OR size=?", '7"',
                                                                                     "Single (7-Inch)"], order_query)
  end

  def eps
    order_query = set_sortable_fields
    @page_num = ParamsParser.parse_page_param(params)
    @sortable_base_url = "/eps"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(@page_num, EbayItem, ["size=? OR size=?",
                                                                                     'EP, Maxi (10, 12-Inch)', '10"'], order_query)
  end

  def lps
    order_query = set_sortable_fields
    @page_num = ParamsParser.parse_page_param(params)
    @sortable_base_url = "/lps"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(@page_num, EbayItem, ["size=? OR size=? OR size=?",
                                                                                     "LP (12-Inch)", "LP", '12"'], order_query)
  end

  def other
    order_query = set_sortable_fields
    @page_num = ParamsParser.parse_page_param(params)
    @sortable_base_url = "/other"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(@page_num, EbayItem, ["size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=?",
                                                                                     "LP (12-Inch)", "LP", 'EP, Maxi (10, 12-Inch)', '10"', '7"', "Single (7-Inch)", '12"'], order_query)
  end

  private

  def set_sortable_fields
    @sort_param, @order_param = ParamsParser.parse_sort_params params
    "#{@sort_param} #{@order_param}"
  end
end