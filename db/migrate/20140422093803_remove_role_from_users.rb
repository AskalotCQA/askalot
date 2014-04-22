class RemoveRoleFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :role, :string, null: false, default: :student
  end
end
