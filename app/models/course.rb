class Course < ApplicationRecord
  enum provider: [:Coursera, :Udacity, :edX, :Udemy]
end
