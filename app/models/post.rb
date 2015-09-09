class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :comments, dependent: :destroy
  has_many :post_categories, foreign_key: :post_id
  has_many :categories, through: :post_categories
  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true
  validates :user_id, presence: true
end
