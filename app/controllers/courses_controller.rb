class CoursesController < ApplicationController
  def search
    query = params[:q]
    if query
      @courses = Course.search(query, limit: 25)
      if @courses.empty?
        flash[:error]  = "Couldn't Find Any Courses :("
        redirect_to search_rand_path
      end
    else
      @courses = Course.limit(10).order("RANDOM()")
    end
  end

  def show
    @course = Course.friendly.find_by_friendly_id(params[:id])
    unless @course
      flash[:error] = "Couldn't find that Course!"
      redirect_to search_rand_path
    end
    @course.views += 1
    @course.save
    @recs = @course.similar(fields: [:title, :short_desc, :category, :header], limit: 6)
  end
end
