class SearchController < ApplicationController

  def search
    searchable_fields = ['artist', 'name', 'description', 'producer', 'band', 'engineer', 'studio']
    query = params[:query].split
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
    @records = Record.all(:conditions => query_exp)
  end

  def append_or(query_exp)
    if (query_exp.length != 0)
      query_exp += ' OR '
    end
    return query_exp
  end
  
end
