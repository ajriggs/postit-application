class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy

  has_secure_password validations: false

  before_save :render_unique_slug!

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

  def to_slug(user)
    user.username.downcase.gsub(/[\W_]/, '-').gsub(/-+/, '-')
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
    duplicate = User.find_by slug: new_slug
    while duplicate && duplicate != self
      new_slug = append_suffix(new_slug)
      duplicate = User.find_by slug: new_slug
    end
    self.slug = new_slug
  end

  def to_param
    self.slug
  end

end
