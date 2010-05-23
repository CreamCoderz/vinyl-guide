module ArrayUtil
  def arrayifiy(array)
    array.is_a?(Array) ? array : [array]
  end
end