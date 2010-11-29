require File.expand_path(File.dirname(__FILE__) + "/../../lib/params_parser")

class SearchController < ApplicationController

  def search
    page_num = ParamsParser.parse_page_param(params)
    @query = ParamsParser.parse_query_param(params)
    @parsed_params = ParamsParser.parse_sort_params(params)
    sort_param = @parsed_params.sort
    order_param = @parsed_params.order
    query = @query

    include_mapped = params[:include_mapped].blank? ? nil : params[:include_mapped] == "true"
    paginated_results = EbayItem.search do
      keywords(query) unless query.blank?
      order_by(sort_param.to_sym, order_param.to_sym)
      with(:mapped, include_mapped) if include_mapped
      paginate(:page => page_num, :per_page => 20)
    end

    @ebay_items = paginated_results.results
    @page_results = Paginator::Result.new(:search_results => paginated_results)

    @sort_param = sort_param
    @order_param = order_param

    @sortable_base_url = "/search?q=#{@query}&page=#{page_num}"
    if request.xml_http_request?
      render :json => {:hits => @page_results.total, :ebay_items => JSON.parse(@page_results.items.to_json(:only => [:id, :title], :methods => [:link]))}
    end
  end

end
