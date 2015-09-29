class Category < ActiveRecord::Base
  has_many :post_categories, foreign_key: :category_id
  has_many :posts, through: :post_categories

  before_save :render_unique_slug

  validates :name, presence: true, length: {minimum: 3}, uniqueness: true

  def self.sorted_index
    Category.all.sort_by { |c| c.name.downcase }
  end

  def to_slug(category)
    category.name.downcase.gsub(/[\W_]/, '-').gsub(/-+/, '-')
  end

  def append_suffix(slug)
    if slug.include?('_')
      slug = slug.succ
    else
      slug += '_1'
    end
  end

  def render_unique_slug
    new_slug = to_slug(self)
    duplicate = Category.find_by slug: new_slug
    while duplicate && duplicate != self
      new_slug = append_suffix(new_slug)
      duplicate = Category.find_by slug: new_slug
    end
    self.slug = new_slug
  end

  def to_param
    self.slug
  end

end
