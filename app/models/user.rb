class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  before_create :generate_uuid_v7
end
