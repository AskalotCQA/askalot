class AddVisibleToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :visible, :boolean, null: false, default: true
  end
end
