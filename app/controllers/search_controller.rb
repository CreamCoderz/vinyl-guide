require File.expand_path(File.dirname(__FILE__) + "/../../lib/params_parser")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/serializer/auto_complete_serializer")

class SearchController < ApplicationController
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']

  def search
    page_num = ParamsParser.parse_page_param(params)
    @query = ParamsParser.parse_query_param(params)
    @sort_param, @order_param = ParamsParser.parse_sort_params(params)
    @ebay_items, @prev, @next, @start, @end, @total = EbayItem.search(:query => @query, :column => @sort_param, :order => @order_param, :page => page_num)
    @sortable_base_url = "/search?q=#{@query}&page=#{page_num}"
    if request.xml_http_request?
     render :json => @ebay_items.to_json(:only => [:title], :methods => [:link])
    end
  end

end
