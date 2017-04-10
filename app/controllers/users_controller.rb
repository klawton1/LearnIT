class UsersController < ApplicationController
  def home
    
  end

  def create
    user = User.new(user_params)
    if user.save
      login(user);
      flash[:success] = "Welcome to LearnIT"
      redirect_to user_path(user)
    else
      flash[:error] = "Not Good"
      redirect_to login_path
    end
  end

  def show
    
  end

  private

  def user_params
    if params[:user][:image].empty?
      params.require(:user).permit(:name, :email, :password)
    else
      params.require(:user).permit(:name, :email, :password, :image)
    end
  end
end
