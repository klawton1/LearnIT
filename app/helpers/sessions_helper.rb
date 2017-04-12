module SessionsHelper
  #Assigns session to user - logs in
  def log_in (user)
    session[:user_id] = user.id
  end

  def current_user?
    unless current_user
      flash[:error] = "Must be logged in to do that"
      redirect_to login_path
    end
  end

  #Confirms user as signed in
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  #Checks if current user is logged in
  def logged_in?
    !!current_user
  end

  #Logs out current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
