class Post < ActiveRecord::Base
  include Voteable
  include Sluggable

  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  sluggable_column :title

  def self.sorted_index
      self.all.sort_by{ |x| x.net_votes }.reverse
  end

  def sorted_comments
    self.comments.all.sort_by{ |x| x.net_votes }.reverse
  end

end
