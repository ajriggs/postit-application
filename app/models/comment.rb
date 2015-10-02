class Comment < ActiveRecord::Base
  include Voteable

  belongs_to :author, class_name: :User, foreign_key: :user_id
  belongs_to :post, dependent: :destroy

  validates :body, presence: true
end
