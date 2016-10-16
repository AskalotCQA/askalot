class ChangeCategoriesFullTreeNameAndFullPublicNameTypes < ActiveRecord::Migration
  def change
    change_column :categories, :full_tree_name, :text
    change_column :categories, :full_public_name, :text
  end
end
