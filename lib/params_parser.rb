module ParamsParser
  def self.parse_sort_params(params)
    ParsedParams.new(params)
  end

  def self.parse_query_param(params)
    params[:q]
  end

  def self.parse_page_param(params)
    page = params[:page]
    page ? page.to_i : 1
  end
end