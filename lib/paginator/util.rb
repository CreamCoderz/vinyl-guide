#TODO: turn this class into a module and use as a mix in for the model classes
module Paginator
  class Util

    PAGE_LIMIT = 20

    def initialize(model_class)
      @model_class = model_class
    end

    #TODO: turn these params into a hash
    def paginate(page_num, conditions=nil, order="id DESC", include=nil)
      item_length = @model_class.count(:all, :conditions => conditions)
      start_index = (page_num - 1) * PAGE_LIMIT
      if (start_index >= item_length || page_num == 0)
        return Paginator::Result.empty_result
      end
      paginated_result = Paginator::Result.new
      end_index = start_index + PAGE_LIMIT - 1

      paginated_result.items = @model_class.find(:all, :order => order, :conditions => conditions, :limit => 20, :offset => start_index, :include => include)
      paginated_result.prev_page_num = (page_num > 1) ? page_num - 1 : nil
      #TODO: find a better way to calculate the next link
      before_end = item_length != end_index + 1
      paginated_result.next_page_num = (before_end && paginated_result.items.length >= PAGE_LIMIT) ? page_num + 1 : nil
      end_len = start_index + paginated_result.items.length
      paginated_result.end_on = end_len == 0 ? nil : end_len
      paginated_result.start_from = paginated_result.end_on.nil? ? nil : start_index + 1
      paginated_result.total = item_length
      paginated_result
    end

  end
end
