require File.expand_path(File.dirname(__FILE__) + "/parsers/params_parser")

class SearchController < ApplicationController
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']

  def search
    do_search(params)
    if request.xml_http_request?
      render :json => make_json_data(@ebay_items)
    end
  end

  private

  def make_json_data(ebay_items)
    ebay_api_items = ""
    ebay_api_hash = []
    ebay_items.each do |ebay_item|
      ebay_api_items += "#{ebay_item.title}|#{ebay_item.id}\n"
      ebay_api_hash.insert(-1, {:title => ebay_item.title, :id => ebay_item.id})
    end
    ebay_api_hash
  end

  def do_search(params)
    page_num = ParamsParser.parse_page_param(params)
    #TODO: query generator needed
    raw_query = ParamsParser.parse_query_param(params)
    wild_query = "%#{raw_query}%"
    query = ''
    SEARCHABLE_FIELDS.each do |searchable_field|
      query = append_or(query)
      query += "#{searchable_field} like :wild_query"
    end
    @sort_param, @order_param = ParamsParser.parse_sort_params(params)
    order_query = " #{@sort_param} #{@order_param}"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, EbayItem, [query, {:wild_query => wild_query}], order_query)
    @query = raw_query
    @sortable_base_url = "/search?q=#{@query}&page=#{page_num}"
  end

  def append_or(query_exp)
    query_exp.length > 0 ? query_exp += ' OR ' : query_exp
  end
end
