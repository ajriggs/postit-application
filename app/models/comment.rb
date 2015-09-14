class Comment < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: :user_id
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true

  def upvotes
    self.votes.where(vote: true).size
  end

  def downvotes
    self.votes.where(vote: false).size
  end

  def net_votes
    upvotes - downvotes
  end
end
