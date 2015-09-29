class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :authored_by_user?

  def logged_in?
    !!session[:user_id]
  end

  def authored_by_user?
    @post.author == current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def require_user
    unless logged_in?
      flash[:error] = 'You must be logged in to do that.'
      redirect_to posts_path
    end
  end

end
