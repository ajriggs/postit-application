class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      flash[:notice] = 'Successfully logged in.'
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error]= 'Username or password incorrect.'
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Successfully logged out.'
    redirect_to root_path
  end

end
