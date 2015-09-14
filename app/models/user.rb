class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 3}, on: :create

  def sorted_posts
    self.posts.all.sort_by{ |x| x.net_votes }.reverse
  end

  def sorted_comments
    self.comments.all.sort_by{ |x| x.net_votes }.reverse
  end
end
