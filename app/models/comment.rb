class Comment < ActiveRecord::Base
  include Voteable

  belongs_to :author, class_name: :User, foreign_key: :user_id
  belongs_to :post

  validates :body, presence: true
end
