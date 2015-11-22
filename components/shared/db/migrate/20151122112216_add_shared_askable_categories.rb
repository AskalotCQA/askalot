class AddSharedAskableCategories < ActiveRecord::Migration
  def change
    add_column :categories, :shared, :boolean, :default => true
    add_column :categories, :askable, :boolean, :default => false
  end
end