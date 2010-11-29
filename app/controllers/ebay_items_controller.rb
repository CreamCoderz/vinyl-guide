require File.expand_path(File.dirname(__FILE__) + "/../../lib/params_parser")
require File.dirname(__FILE__) + '/../../lib/paginator/util'

class EbayItemsController < ApplicationController
  PAGE_LIMIT = 20

  before_filter :set_sortable_fields, :only => [:all, :singles, :eps, :lps, :other, :home]
  before_filter :set_page_num, :only => [:all, :singles, :eps, :lps, :other]
  before_filter :find_ebay_item, :only => [:edit, :update, :show]
  before_filter :set_release, :only => [:show]

  def initialize
    @paginator = Paginator::Util.new(EbayItem)
  end

  def index
    @release = Release.find(params[:release_id], :include => :ebay_items)
    @ebay_items = @release.ebay_items
  end

  def edit
  end

  def update
    if @ebay_item.update_attributes(params[:ebay_item])
      flash[:notice] = 'The auction was successfully updated.'
      if request.xhr?
        @controls = true
        render :template => "partials/_ebay_item_abbrv.erb", :layout => false, :locals => {:ebay_item => @ebay_item}
      else
        redirect_to ebay_item_path(@ebay_item)
      end
    else
      render :action => "edit"
    end
  end

  def home
    @ebay_items = EbayItem.find(:all, :order => @order_query, :limit => PAGE_LIMIT)
  end

  def show
    @ebay_item = EbayItem.find(params[:id], :include => [{:release => [:label_entity, :format, :ebay_items]}, :pictures])
    @related_ebay_items = []
    releases = @ebay_item.release
    @related_ebay_items = releases.ebay_items.inject([]) { |memo, ebay_item| memo << ebay_item unless @ebay_item == ebay_item; memo } if releases
  end

  def all
    @sortable_base_url = "/all"
    @page_results = Paginator::Result.new(:paginated_results => EbayItem.paginate(:order => @order_query, :page => @page_num))
  end

  def singles
    @sortable_base_url = "/singles"
    @page_results = Paginator::Result.new(:paginated_results => EbayItem.singles.paginate(:page => @page_num, :order => @order_query))
  end

  def eps
    @sortable_base_url = "/eps"
    @page_results = Paginator::Result.new(:paginated_results => EbayItem.eps.paginate(:page => @page_num, :order => @order_query))    
  end

  def lps
    @sortable_base_url = "/lps"
    @page_results = Paginator::Result.new(:paginated_results => EbayItem.lps.paginate(:page => @page_num, :order => @order_query))
  end

  def other
    @sortable_base_url = "/other"
    @page_results = Paginator::Result.new(:paginated_results => EbayItem.other.paginate(:page => @page_num, :order => @order_query))        
  end

  private

  def set_sortable_fields
    parsed_params = ParamsParser.parse_sort_params(params)
    @sort_param, @order_param = parsed_params.sort, parsed_params.order
    @order_query = "#{@sort_param} #{@order_param}"
  end

  def set_page_num
    @page_num = ParamsParser.parse_page_param(params)
  end

  def find_ebay_item
    @ebay_item = EbayItem.find(params[:id])
  end

  def set_release
    @release = Release.new
    @release.label_entity = Label.new
  end
end