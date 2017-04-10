class CoursesController < ApplicationController
  def search
    query = params[:q]
    if query
      @courses = Course.search(query)
      if @courses.empty?
        flash[:error]  = "Couldn't Find Any Courses :("
        redirect_to search_rand_path
      end
    else
      @courses = Course.limit(10).order("RANDOM()")
    end
  end

  def show
    @course = Course.find_by_id(params[:id])
    unless @course
      flash[:error] = "Couldn't find that Course!"
      redirect_to search_rand_path
    end
    @course
  end
end
