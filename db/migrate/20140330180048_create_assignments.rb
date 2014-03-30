class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :user,     null: false
      t.references :role,     null: false
      t.references :category, null: false

      t.timestamps
    end

    add_index :assignments, :user_id
    add_index :assignments, :role_id
    add_index :assignments, :category_id
  end
end
