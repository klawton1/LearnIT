class Course < ApplicationRecord
  searchkick
  enum provider: [:Coursera, :Udacity, :edX, :Udemy]
  has_many :interests, dependent: :destroy
  has_many :users, through: :interests
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
end
