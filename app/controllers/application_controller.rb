class ApplicationController < ActionController::Base
  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']

  protect_from_forgery
end
