module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :render_unique_slug!
    class_attribute :slugged_column
  end

  def to_slug(string)
    string.downcase.gsub(/[\W_]/, '-').gsub(/-+/, '-')
  end

  def append_suffix(slug)
    if slug.include?('_')
      slug = slug.succ
    else
      slug += '_1'
    end
  end

  def render_unique_slug!
    new_slug = to_slug(self.send(self.class.slugged_column.to_sym))
    duplicate = self.class.find_by slug: new_slug
    while duplicate && duplicate != self
      new_slug = append_suffix(new_slug)
      duplicate = self.class.find_by slug: new_slug
    end
    self.slug = new_slug
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(column_name)
      self.slugged_column = column_name
    end
  end

end
