class ParamsParser
  SORTABLE_FIELDS = ['endtime', 'price', 'title']
  ORDER_FIELDS = ['desc', 'asc']

  def self.parse_sort_params(params)
    sort, order = params[:sort], params[:order]
    sort_param = SORTABLE_FIELDS[0]
    order_param = ORDER_FIELDS[0]
    if sort and SORTABLE_FIELDS.include?(sort.downcase)
      sort_param = sort
    end
    if order and ORDER_FIELDS.include?(order.downcase)
      order_param = order
    end
    [sort_param, order_param]
  end

  def self.parse_query_param(params)
    params[:q]
  end

  def self.parse_page_param(params)
    page = params[:page]
    page ? page.to_i : 1
  end
end