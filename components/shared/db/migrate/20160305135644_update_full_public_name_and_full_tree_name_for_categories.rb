class UpdateFullPublicNameAndFullTreeNameForCategories < ActiveRecord::Migration
  def up
    Shared::Category.unscoped.find_each do |category|
      category.refresh_full_tree_name
      category.refresh_full_public_name

      category.save!
    end
  end
end
