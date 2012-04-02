class SessionsController < Devise::SessionsController

  def new
    flash.now[:notice] = params[:message] if params[:message]
    @redirect_url = request.env["HTTP_REFERER"]
    super
  end

  def after_sign_in_path_for(resource)
    params[:redirect_url] || root_path
  end

end