class ApplicationController < ActionController::Base
  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']

  protect_from_forgery

  def authorize_user
    render :nothing => true, :status => :forbidden if current_user.id != params[:id].to_i
  end

  def authorize_nested_user
    render :nothing => true, :status => :forbidden if current_user.id != params[:user_id].to_i
  end
end
