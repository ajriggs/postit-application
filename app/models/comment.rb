class Comment < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: :user_id
  belongs_to :post, dependent: :destroy
  has_many :votes, as: :voteable

  after_create :render_slug

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

  def render_slug
    self.slug = self.created_at.to_s.downcase.gsub(/[\W]/, '-').gsub(/-+/, '-')
    self.save
  end

  def to_param
    self.slug
  end
end
