class SearchController < ApplicationController

  def search
    searchable_fields = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']
    raw_query = params[:query]
    page = params[:page]
    page_num = page ? page.to_i : 1
    #TODO: query generator needed
    wild_query = "%#{raw_query}%"
    query_exp = ''
    wild_sub_query = ''
    searchable_fields.each do |searchable_field|
      wild_sub_query = append_or(wild_sub_query)
      wild_sub_query += "#{searchable_field} like :wild_query"
    end
    query_exp += wild_sub_query
    
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, EbayItem, [query_exp, {:wild_query => wild_query}])
    @query = raw_query
  end

  def append_or(query_exp)
    if (query_exp.length != 0)
      query_exp += ' OR '
    end
    return query_exp
  end

end
