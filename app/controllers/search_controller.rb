class SearchController < ApplicationController
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']
  SORTABLE_FIELDS = ['endtime', 'price', 'title']

  def search
    do_search(params[:q], params[:sort])
    if request.xml_http_request?
      ebay_api_items = ""
      ebay_api_hash = []
      @ebay_items.each do |ebay_item|
        ebay_api_items += "#{ebay_item.title}|#{ebay_item.id}\n"
        ebay_api_hash.insert(-1, {:title => ebay_item.title, :id => ebay_item.id})
      end
      render :json => ebay_api_hash
    end
  end

  private

  def do_search(raw_query, order)
    page = params[:page]
    page_num = page ? page.to_i : 1
    #TODO: query generator needed
    wild_query = "%#{raw_query}%"
    query = ''
    SEARCHABLE_FIELDS.each do |searchable_field|
      query = append_or(query)
      query += "#{searchable_field} like :wild_query"
    end
    order_query = SORTABLE_FIELDS[0]
    if order
      order_query = order if SORTABLE_FIELDS.include?(order.downcase)
    end
    order_query += " DESC"
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, EbayItem, [query, {:wild_query => wild_query}], order_query)
    @query = raw_query
  end

  def append_or(query_exp)
    if (query_exp.length != 0)
      query_exp += ' OR '
    end
    return query_exp
  end
end
