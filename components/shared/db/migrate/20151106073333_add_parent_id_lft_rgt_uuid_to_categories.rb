class AddParentIdLftRgtUuidToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :parent_id, :integer
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :uuid, :string

    Shared::Category.rebuild!
  end
end