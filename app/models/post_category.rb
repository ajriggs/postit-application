class PostCategory < ActiveRecord::Base
  belongs_to :post, foreign_key: :post_id
  belongs_to :category, foreign_key: :category_id
end
