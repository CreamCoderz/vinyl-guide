class Command

  def initialize(arg, function)
    @arg = arg
    @function = function
  end

  def execute
    @function.call(@arg)
  end

  def to_s
    @arg
  end
end