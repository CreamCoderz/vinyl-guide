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
    @related_ebay_items = @ebay_item.related_items
  end

  def all
    @sortable_base_url = "/all"
    set_page_results(:all_items)
  end

  def singles
    @sortable_base_url = "/singles"
    set_page_results(:singles)
  end

  def eps
    @sortable_base_url = "/eps"
    set_page_results(:eps)
  end

  def lps
    @sortable_base_url = "/lps"
    set_page_results(:lps)
  end

  def other
    @sortable_base_url = "/other"
    set_page_results(:other)
  end

  private

  def set_sortable_fields
    @parsed_params = ParamsParser.parse_sort_params(params)
    @sort_param, @order_param, @time = @parsed_params.sort, @parsed_params.order, @parsed_params.time
    @order_query = "#{@sort_param} #{@order_param}"
  end

  def set_page_results(scope)
    ebay_items = EbayItem.send(scope)
    ebay_items = ebay_items.send(@time) unless @time == 'all'
    ebay_items = ebay_items.all.paginate(:order => @order_query, :page => @page_num)
    @page_results = Paginator::Result.new(:paginated_results => ebay_items)
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