class CreateRoleAssignments < ActiveRecord::Migration
  def change
    create_table :role_assignments do |t|
      t.references :user,     null: false
      t.references :role,     null: false
      t.references :category, null: false

      t.timestamps
    end

    add_index :role_assignments, :user_id
    add_index :role_assignments, :role_id
    add_index :role_assignments, :category_id
  end
end
