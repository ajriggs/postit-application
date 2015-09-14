class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :comments, dependent: :destroy
  has_many :post_categories, foreign_key: :post_id
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  def upvotes
    self.votes.where(vote: true).size
  end

  def downvotes
    self.votes.where(vote: false).size
  end

  def net_votes
    upvotes - downvotes
  end

  def self.sorted_index
      Post.all.sort_by{ |x| x.net_votes }.reverse
  end

  def sorted_comments
    self.comments.all.sort_by{ |x| x.net_votes }.reverse
  end
end
