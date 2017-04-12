class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      log_in user
      redirect_to user_path(user)
      flash[:success] = "Welcome back, #{user.name}!"
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to login_path
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
