class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :comments, dependent: :destroy
  has_many :post_categories, foreign_key: :post_id
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  before_create :render_unique_slug!

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

  def to_slug(post)
    post.title.downcase.gsub(/[\W_]/, '-').gsub(/-+/, '-')
  end

  def append_suffix(slug)
    if slug.include?('_')
      slug = slug.succ
    else
      slug += '_1'
    end
  end

  def render_unique_slug!
    new_slug = to_slug(self)
    duplicate = Post.find_by slug: new_slug
    while duplicate && duplicate != self
      new_slug = append_suffix(new_slug)
      duplicate = Post.find_by slug: new_slug
    end
    self.slug = new_slug
  end

  def to_param
    self.slug
  end

end
