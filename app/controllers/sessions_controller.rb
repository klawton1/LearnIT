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
      flash.now[:danger] = 'Invalid email/password combination'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
