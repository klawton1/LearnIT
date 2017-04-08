class CoursesController < ApplicationController
  def search
    query = params[:q]
    @courses = Course.search(query)
  end

  def show
    
  end
end
