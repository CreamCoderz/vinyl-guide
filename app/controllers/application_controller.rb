# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  PAGE_LIMIT = 20

  def paginate(page_num, items)
    start_index = (page_num - 1) * PAGE_LIMIT
    end_index = start_index + PAGE_LIMIT - 1
    truncated_items = items[start_index..end_index]
    prev_page_num = (page_num > 1) ? page_num - 1 : nil
    #TODO: find a better way to calculate the next link
    before_end = items.length != end_index + 1
    next_page_num = (before_end && truncated_items.length >= PAGE_LIMIT) ? page_num + 1 : nil
    start_from = start_index + 1
    end_on = start_index + truncated_items.length
    total = items.length
    return truncated_items, prev_page_num, next_page_num, start_from, end_on, total
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
