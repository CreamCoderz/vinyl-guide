class Paginator::Result
  attr_accessor :items, :prev_page_num, :next_page_num, :start_from, :end_on, :total

  def initialize(params={})
    params.each_key do |key|
      instance_variable_set("@#{key}", params[key])
    end
  end

  def empty?
    @items.blank? || @items.empty?
  end

  def self.empty_result
    Paginator::Result.new(:items => [], :prev_page_num => nil, :next_page_num => nil, :start_from => nil,
                          :end_on => nil, :total => 0)
  end
end