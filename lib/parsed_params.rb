class ParsedParams
  attr_reader :sort, :order, :time, :q

  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']
  TIME_OPTIONS = ['all_time', 'today', 'week', 'month']
  DEFAULTING_OPTIONS = {:sort => SORTABLE_OPTIONS, :order => ORDER_OPTIONS, :time => TIME_OPTIONS}
  ACCEPTED_PARAMS = [:q]

  def initialize(params)
    @selected_options = {}
    @selected_params = {}

    parsed_params = DEFAULTING_OPTIONS.inject({}) do |memo, key_and_options|
      memo[key_and_options.first] = set_default_param(key_and_options.last, params[key_and_options.first], key_and_options.first)
      memo
    end
    ACCEPTED_PARAMS.each do |param|
      if params[param]
        instance_variable_set("@#{param}", params[param])
        @selected_params[param] = params[param]
      end
    end
    parsed_params.each_pair { |key, value| instance_variable_set("@#{key}", value) }
  end

  def selected?(param, param_value)
    (@selected_options.empty? && param == :sort && param_value.to_sym == :endtime) ? true : @selected_options[param] == param_value
  end

  def declared?(param)
    @selected_options.include?(param) || @selected_params.include?(param)
  end

  def [](key)
    instance_variable_get("@#{key}")
  end

  def selected
    @selected_options.merge(@selected_params).clone
  end

  private

  def set_default_param(accepted_options, param, key)
    if param && accepted_options.include?(param.downcase)
      @selected_options[key] = param.downcase
      param
    else
      accepted_options.first
    end
  end

  def any_param_option_chosen?
    @selected_options.empty?
  end
end
