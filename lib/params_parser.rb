module ParamsParser
  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']
  TIME_OPTIONS = ['all', 'today', 'week', 'month']

  class ParsedParams
    attr_reader :sort, :order, :time

    PARAM_OPTIONS = {:sort => SORTABLE_OPTIONS, :order => ORDER_OPTIONS, :time => TIME_OPTIONS}

    def initialize(params)
      @selected = {}
      parsed_params = PARAM_OPTIONS.inject({}) do |memo, key_and_options|
        memo[key_and_options.first] = set_default_param(key_and_options.last, params[key_and_options.first], key_and_options.first)
        memo
      end
      parsed_params.each_pair { |key, value| instance_variable_set("@#{key}", value) }
    end

    def selected?(param, param_value)
      @selected.empty? && param == :sort && param_value.to_sym == :endtime ? true : @selected[param] == param_value
    end

    def declared?(param)
      @selected.include? param
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    private

    def set_default_param(accepted_options, param, key)
      if param && accepted_options.include?(param.downcase)
        @selected[key] = param.downcase
        param
      else
        accepted_options.first
      end
    end
  end

  #TODO: clean this up
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