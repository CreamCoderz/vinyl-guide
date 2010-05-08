require File.expand_path(File.dirname(__FILE__) + "/parsers/params_parser")

class SearchController < ApplicationController
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']

  def search
    page_num = ParamsParser.parse_page_param(params)
    @query = ParamsParser.parse_query_param(params)
    @sort_param, @order_param = ParamsParser.parse_sort_params(params)
    @ebay_items, @prev, @next, @start, @end, @total = EbayItem.search(:query => @query, :column => @sort_param, :order => @order_param, :page => page_num)
    @sortable_base_url = "/search?q=#{@query}&page=#{page_num}"
    if request.xml_http_request?
      render :json => make_json_data(@ebay_items)
    end
  end

  private

  #TODO: this isn't json.. what happened to the json handling on the client side and code here?
  def make_json_data(ebay_items)
    ebay_api_items = ""
    ebay_api_hash = []
    ebay_items.each do |ebay_item|
      ebay_api_items += "#{ebay_item.title}|#{ebay_item.id}\n"
      ebay_api_hash.insert(-1, {:title => ebay_item.title, :id => ebay_item.id})
    end
    ebay_api_hash
  end

end
