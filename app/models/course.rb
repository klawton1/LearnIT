class Course < ApplicationRecord
  searchkick
  enum provider: [:Coursera, :Udacity, :edX, :Udemy]
end
