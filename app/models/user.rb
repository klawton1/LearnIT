class User < ApplicationRecord
  has_secure_password
  has_many :interests, dependent: :destroy
  has_many :courses, through: :interests
end
