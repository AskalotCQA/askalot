module Shared::Administration::FilterableCategories
  extend ActiveSupport::Concern

  def include_only_child_categories(categories, parent_ids)
    where = "categories.depth <= 1 OR ("

    parent_ids.each_with_index do |filtered_category, index|
      category = Shared::Category.find(filtered_category)

      where += "#{index > 0 ? 'OR' : ''} (categories.lft >= #{category.lft} AND categories.lft <= #{category.rgt})"
    end

    categories = categories.where("#{where})")
  end
end
