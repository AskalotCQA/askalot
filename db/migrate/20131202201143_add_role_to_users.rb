class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, null: false

    add_index :users, :role
  end
end
