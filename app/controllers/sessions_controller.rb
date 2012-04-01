class SessionsController < Devise::SessionsController

  def new
    flash.now[:notice] = params[:message] if params[:message]
    super
  end

end