module ArrayUtil
  def self.arrayifiy(array)
    array.is_a?(Array) ? array : [array]
  end
end