class AddUniqueIndexToCategories < ActiveRecord::Migration
  def change
    add_index :categories, [:parent_id, :uuid, :lti_id], unique: true
  end
end
