class AddFlagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :flag_show_name,  :boolean, null: false, default: true
    add_column :users, :flag_show_email, :boolean, null: false, default: true
  end
end
