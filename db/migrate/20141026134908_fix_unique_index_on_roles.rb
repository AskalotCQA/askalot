class FixUniqueIndexOnRoles < ActiveRecord::Migration
  def change
    remove_index :roles, column: :name

    add_index :roles, :name, unique: true
  end
end
