class Paginator

  PAGE_LIMIT = 20

  def initialize(model_class)
    @model_class = model_class
  end

  def paginate(page_num, conditions=nil, order="id DESC")
    item_length = @model_class.count(:all, :conditions => conditions)
    start_index = (page_num - 1) * PAGE_LIMIT
    if (start_index >= item_length || page_num == 0)
      return [], nil, nil, nil, nil, 0
    end
    end_index = start_index + PAGE_LIMIT - 1
    truncated_items = @model_class.find(:all, :order => order, :conditions => conditions, :limit => 20, :offset => start_index)
    prev_page_num = (page_num > 1) ? page_num - 1 : nil
    #TODO: find a better way to calculate the next link
    before_end = item_length != end_index + 1
    next_page_num = (before_end && truncated_items.length >= PAGE_LIMIT) ? page_num + 1 : nil
    end_len = start_index + truncated_items.length
    end_on = end_len == 0 ? nil : end_len
    start_from = end_on.nil? ? nil : start_index + 1
    total = item_length
    return truncated_items, prev_page_num, next_page_num, start_from, end_on, total
  end

end
