class UpdateFullPublicNameAndFullTreeNameAndPublicTagsForCategories < ActiveRecord::Migration
  def up
    Shared::Category.unscoped.find_each do |category|
      category.refresh_full_tree_name
      category.refresh_full_public_name
      category.public_tags = category.self_and_ancestors.map { |ancestor| ancestor.tags }.flatten.uniq.sort

      category.save!
    end
  end
end
