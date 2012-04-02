class ApplicationController < ActionController::Base
  SORTABLE_OPTIONS = ['endtime', 'price', 'title']
  ORDER_OPTIONS = ['desc', 'asc']

  protect_from_forgery

  def authorize_user
    if current_user.id != params[:id].to_i
      respond_to do |format|
        format.html { render :nothing => true, :status => :forbidden }
        format.json { render :json => {:error => "You are not authorized to take this action"}, :status => :forbidden }
      end
    end
  end

  def authorize_nested_user
    if current_user.id != params[:user_id].to_i
      respond_to do |format|
        format.html { render :nothing => true, :status => :forbidden }
        format.json { render :json => {:error => "You are not authorized to take this action"}, :status => :forbidden }
      end
    end
  end
end
