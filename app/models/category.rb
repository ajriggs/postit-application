class Category < ActiveRecord::Base
  include Sluggable

  has_many :post_categories, foreign_key: :category_id
  has_many :posts, through: :post_categories

  validates :name, presence: true, length: {minimum: 3}, uniqueness: true

  sluggable_column :name

  def self.sorted_index
    self.all.sort_by { |c| c.name.downcase }
  end
end
