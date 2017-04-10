class UsersController < ApplicationController
  before_action :get_user,          only: [:update, :edit, :show]
  before_action :is_current_user,   only: [:update, :edit, :show]
  before_action :validate_password, only: [:update]
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

  def edit
  end

  def update
    if current_user.update(user_params);
      redirect_to user_path(current_user)
    else
      flash[:error] = "Could not update User"
      redirect_to root_path
    end
  end

  def show
    
  end

  private

  def get_user
    @user = User.find_by_id(params[:id])
  end

  def is_current_user
    if @user != current_user
      flash[:error] = "Dont Have Permission to do That"
      redirect_to search_rand_path
    end
  end

  def user_params
    if params[:user][:image].empty?
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    else
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end
  end

  def validate_password
    if params[:user][:password_confirmation] != user_params[:password]
      flash[:error] = "Passwords don't match"
      redirect_to edit_user_path(@user)
    end

    if user_params[:password].empty?
      flash[:error] = "Please Enter a Password"
      redirect_to edit_user_path(@user)
    end
  end

end
