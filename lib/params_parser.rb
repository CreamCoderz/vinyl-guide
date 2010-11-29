module ParamsParser
  SORTABLE_FIELDS = ['endtime', 'price', 'title']
  ORDER_FIELDS = ['desc', 'asc']
  TIMES = ['all', 'today', 'week', 'month']

  class ParsedParams
    attr_reader :sort, :order, :time

    def initialize(params)
      params.each_pair { |key, value| instance_variable_set("@#{key}", value) }
    end
  end

  #TODO: clean this up
  def self.parse_sort_params(params)
    sort, order, time = params[:sort], params[:order], params[:time]
    sort_param = SORTABLE_FIELDS[0]
    order_param = ORDER_FIELDS[0]
    time_param = TIMES[0]
    sort_param = sort if sort && SORTABLE_FIELDS.include?(sort.downcase)
    order_param = order if order && ORDER_FIELDS.include?(order.downcase)
    time_param = time if time && TIMES.include?(time.downcase)
    ParsedParams.new(:sort => sort_param, :order => order_param, :time => time_param)
  end

  def self.parse_query_param(params)
    params[:q]
  end

  def self.parse_page_param(params)
    page = params[:page]
    page ? page.to_i : 1
  end
end