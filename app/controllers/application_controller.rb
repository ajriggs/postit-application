class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :sorted_posts, :sorted_comments

  def logged_in?
    !!session[:user_id]
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

  def sorted_posts(user = false)
    if user
      @user.posts.all.sort_by{ |x| x.net_votes }.reverse
    else
      Post.all.sort_by{ |x| x.net_votes }.reverse
    end
  end

  def sorted_comments(parent_asset)
    parent_asset.comments.all.sort_by{ |x| x.net_votes }.reverse
  end
end
