class SearchController < ApplicationController

  def search
    searchable_fields = ['itemid', 'description', 'url', 'galleryimg', 'sellerid']
    raw_query = params[:query]
    page = params[:page]
    page_num = page ? page.to_i : 1
    #TODO: query generator needed
    query = raw_query.split
    wild_query = []
    query_exp = ''
    i=0
    query.each do |single_query|
      query_exp = append_or(query_exp)
      wild_query[i] = '%' + single_query + '%'
      wild_sub_query = ''
      searchable_fields.each do |searchable_field|
        wild_sub_query = append_or(wild_sub_query)
        wild_sub_query += searchable_field + ' like \'' + wild_query[i] +'\''
      end
      query_exp += wild_sub_query
      i += 1
    end
    ebay_items = EbayItem.all(:conditions => query_exp, :order => "id DESC")
    @ebay_items, @prev, @next, @start, @end, @total = paginate(page_num, ebay_items)
    @query = raw_query
  end

  def append_or(query_exp)
    if (query_exp.length != 0)
      query_exp += ' OR '
    end
    return query_exp
  end

end
