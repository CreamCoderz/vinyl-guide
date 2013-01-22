class CommentsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy]

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Thanks for your comment."
    else
      flash[:error] = @comment.errors.full_messages
    end
    redirect_to request.referrer
  end

  def destroy
    comment = Comment.find(params[:id])
    if current_user == comment.user
      comment.destroy
      flash[:notice] = "Your comment was successfully removed"
      redirect_to request.referrer
    else
      flash[:error] = "You may only delete a comment that you have authored"
      redirect_to request.referrer
    end
  end

  def index
    @comments = Comment.with_recent_unique_parents.paginate(:page => params[:page], :per_page => 50)
    @comments.each { |comment| comment.parent.comment = comment }
  end

  def show
    @comment = Comment.find(params[:id])
  end
end