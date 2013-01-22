class SearchController < ApplicationController

  before_filter :set_favorites

  def search
    page_num = ParamsParser.parse_page_param(params)
    @query = ParamsParser.parse_query_param(params)
    @parsed_params = ParamsParser.parse_sort_params(params)
    sort_param = @parsed_params.sort
    order_param = @parsed_params.order
    query = @query

    if @query.present?
      include_mapped = params[:include_mapped].blank? ? nil : params[:include_mapped] == "true"
      paginated_results = EbayItem.search do
        keywords(query) unless query.blank?
        order_by(sort_param.to_sym, order_param.to_sym)
        with(:mapped, include_mapped) if include_mapped
        paginate(:page => page_num, :per_page => 20)
      end
      @page_results = Paginator::Result.new(:paginated_results => paginated_results.results)
    else
      @page_results = Paginator::Result.empty_result
      flash.now[:notice] = 'You must enter a search query'
    end

    if request.xml_http_request?
      render :json => {:hits => @page_results.total, :ebay_items => JSON.parse(@page_results.items.to_json(:only => [:id, :title], :methods => [:link]))}
    end
  rescue Errno::ECONNREFUSED
    flash.now[:error] = 'Search is currently down. My sincerest apologies.'
    render :text => '', :layout => true
  end

  private

  def set_favorites
    @favorites = current_user.present? ? current_user.favorites : []
  end

end
