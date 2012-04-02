class FavoritesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy, :index]
  before_filter :authorize_nested_user, :only => [:create, :destroy, :index]
  before_filter :assign_user

  def create
    favorite_attributes = params[:favorite] || {}
    favorite_attributes.merge!(:user_id => params[:user_id])
    favorite = Favorite.new(favorite_attributes)
    respond_to do |format|
      if favorite.save
        format.html { redirect_to request.referrer, :notice => "The auction has been added to your favorites" }
        format.json do
          favorite_json = favorite.as_json
          favorite_json['favorite'].merge!(:delete_uri => user_favorite_path(favorite.user, favorite, :format => 'json'))
          render :json => favorite_json
        end
      else
        format.html { redirect_to request.referrer, :notice => "An error occurred. #{favorite.errors.full_messages}" }
        format.json { render :json => {:error => favorite.errors.full_messages}, :status => 400 }
      end
    end
  end

  def index
    @favorites = Favorite.where(:user_id => params[:user_id]).paginate(:per_page => 20, :page => params[:page])
    @page_results = Paginator::Result.new(:paginated_results => @favorites)
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json do
        favorite_json = favorite.as_json
        favorite_json['favorite'].merge!(:create_uri => user_favorites_path(favorite.user, :format => 'json'))
        render :json => favorite_json
      end
    end
  end

  private

  def assign_user
    @user = User.find(params[:user_id])
  end
end