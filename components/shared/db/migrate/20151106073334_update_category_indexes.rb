class UpdateCategoryIndexes < ActiveRecord::Migration
  def change
    remove_index :categories, column: :name
    add_index :categories, [:name, :parent_id], unique: true
  end
end