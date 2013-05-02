class Admin::AdminController < ApplicationController

  before_filter :authorize_admin

  def authorize_admin
    unless current_user.present? && current_user.admin?
      flash[:notice] = "You are not authorize to perform this action"
      redirect_to root_path
    end
  end
end