# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  PAGE_LIMIT = 20

  def paginate(page_num, active_record_class, conditions=nil, order="id DESC")
    item_length = active_record_class.count(:all, :conditions => conditions)
    start_index = (page_num - 1) * PAGE_LIMIT
    if (start_index >= item_length || page_num == 0)
      return [], nil, nil, nil, nil, 0
    end
    end_index = start_index + PAGE_LIMIT - 1
    truncated_items = active_record_class.find(:all, :order => order, :conditions => conditions, :limit => 20, :offset => start_index)
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

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
