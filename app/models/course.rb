class Course < ApplicationRecord
  extend FriendlyId
  searchkick
  enum provider: [:Coursera, :Udacity, :edX, :Udemy]
  has_many :interests, dependent: :destroy
  has_many :users, through: :interests
  friendly_id :title, use: :slugged
end
