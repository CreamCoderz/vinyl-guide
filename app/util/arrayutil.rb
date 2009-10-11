module ArrayUtil

  def self.arrayifiy(array)
    if !array.is_a?(Array)
      array = [array]
    end
    array
  end
end