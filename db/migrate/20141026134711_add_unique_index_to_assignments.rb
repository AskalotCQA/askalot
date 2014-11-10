class AddUniqueIndexToAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:user_id, :category_id], unique: true
  end
end
