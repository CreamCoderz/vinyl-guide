class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:show]
  before_filter :authorize_user, :only => [:show]

  def show
    @user = User.find(params[:id])
    @favorites = @user.favorites.limit(3)
    @comments = @user.comments.limit(3)
  end

end