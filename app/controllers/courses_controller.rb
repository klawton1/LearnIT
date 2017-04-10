class CoursesController < ApplicationController
  def search
    query = params[:q]
    if query
      @courses = Course.search(query)
    else
      @courses = Course.limit(10).order("RANDOM()")
    end
  end

  def show
    @course = Course.find_by_id(params[:id])
    unless @course
      flash[:error] = "Couldn't find that Course!"
      redirect_to(current_user)
    end
    @course
  end
end
