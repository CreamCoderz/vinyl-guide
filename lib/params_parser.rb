module ParamsParser
  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']
  TIME_OPTIONS = ['all_time', 'today', 'week', 'month']

  class ParsedParams
    attr_reader :sort, :order, :time, :q

    PARAM_OPTIONS = {:sort => SORTABLE_OPTIONS, :order => ORDER_OPTIONS, :time => TIME_OPTIONS}
    ACCEPTED_PARAMS = [:q]

    def initialize(params)
      @selected = {}
      parsed_params = PARAM_OPTIONS.inject({}) do |memo, key_and_options|
        memo[key_and_options.first] = set_default_param(key_and_options.last, params[key_and_options.first], key_and_options.first)
        memo
      end
      ACCEPTED_PARAMS.each do |param|
        if params[param]
          instance_variable_set("@#{param}", params[param])
          @selected[param] = params[param]
        end
      end
      parsed_params.each_pair { |key, value| instance_variable_set("@#{key}", value) }
    end

    # hack to ignore the 'q' param and consider 'endtime' selected. find a better way to deal with this.
    def selected?(param, param_value)
      (@selected.empty? || @selected[ACCEPTED_PARAMS.first].present?) && param == :sort && param_value.to_sym == :endtime ? true : @selected[param] == param_value
    end

    def declared?(param)
      @selected.include? param
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    def selected
      @selected.clone
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

    def any_param_option_chosen?
      @selected.empty?
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