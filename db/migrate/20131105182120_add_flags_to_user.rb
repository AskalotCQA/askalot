class AddFlagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :flag_name, :boolean
    add_column :users, :flag_email, :boolean
  end
end
