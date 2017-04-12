class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def page_not_found
    flash[:error] = "Couldn't find that page :("
    redirect_to search_rand_path
  end
end
