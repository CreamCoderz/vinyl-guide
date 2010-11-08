class Paginator::Result
  attr_accessor :items, :prev_page_num, :next_page_num, :start_from, :end_on, :total

  def initialize(params={})
    if params.has_key? :paginated_results
      paginated_results = params[:paginated_results]
      items = paginated_results.results
      @end_on = [items.offset + items.per_page, paginated_results.total].min
      @prev_page_num = items.previous_page
      @next_page_num = items.next_page
      @start_from = items.offset + 1
      @items = items
      @total = paginated_results.total
    else
      params.each_key do |key|
        instance_variable_set("@#{key}", params[key])
      end
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