class User < ApplicationRecord
  has_secure_password
  has_many :interests
  has_many :courses, through: :interests
end
