class SessionsController < ApplicationController
  before_action :require_valid_password, only: [:authenticate]

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      unless user.two_factor?
        login! user
      else
        session[:two_factor_ready?] = true
        user.render_pin!
        user.send_pin_through_twilio
        redirect_to authenticate_path
      end
    else
      login_failed
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Successfully logged out.'
    redirect_to root_path
  end

  def authenticate
    if request.post?
      user = User.find_by pin: params[:pin]
      if user
        user.clear_pin!
        session[:two_factor_ready?] = nil
        login! user
      else
        login_failed
      end
    end
  end

  private

  def require_valid_password
    access_denied unless session[:two_factor_ready?]
  end

  def login!(user)
    session[:user_id] = user.id
    flash[:notice] = "Welcome, #{user.username}!"
    redirect_to root_path
  end

  def login_failed
    flash[:error] = "Oops! Your credentials were incorrect. Please try again."
    redirect_to :back
  end

end
