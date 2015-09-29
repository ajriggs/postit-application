class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy

  has_secure_password validations: false

  before_save :render_slug

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 3}, on: :create

  def safe_username
    /[\\\/|~`,.<>?;:\[\]{}!@#$%^&*()+= ]/
  end

  def sorted_posts
    self.posts.all.sort_by{ |x| x.net_votes }.reverse
  end

  def sorted_comments
    self.comments.all.sort_by{ |x| x.net_votes }.reverse
  end

  def render_slug
    self.slug = self.username.downcase.gsub(/[\W]/, '-').gsub(/-+/, '-')
  end

  def to_param
    self.slug
  end

end
