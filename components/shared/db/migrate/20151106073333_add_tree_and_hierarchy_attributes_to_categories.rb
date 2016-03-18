class AddTreeAndHierarchyAttributesToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :parent_id, :integer
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :uuid, :string
    add_column :categories, :depth, :integer, index: true

    add_column :categories, :full_tree_name, :string, index: true
    add_column :categories, :full_public_name, :string, index: true
    add_column :categories, :public_tags, :string, array: true, default: []

    add_column :categories, :shared, :boolean, :default => true
    add_column :categories, :askable, :boolean, :default => false

    add_index :categories, :lft
    add_index :categories, :rgt

    Shared::Category.rebuild!
  end


  def down
    remove_column :categories, :parent_id
    remove_column :categories, :lft
    remove_column :categories, :rgt
    remove_column :categories, :uuid
    remove_column :categories, :depth

    remove_column :categories, :full_tree_name
    remove_column :categories, :full_public_name
    remove_column :categories, :public_tags

    remove_column :categories, :shared
    remove_column :categories, :askable

    remove_index :categories, :lft
    remove_index :categories, :rgt
  end
end
