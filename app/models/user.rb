class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 3}, on: :create

end
