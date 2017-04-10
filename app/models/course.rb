class Course < ApplicationRecord
  searchkick
  enum provider: [:Coursera, :Udacity, :edX, :Udemy]
  has_many :interests, dependent: :destroy
  has_many :users, through: :interests
end
