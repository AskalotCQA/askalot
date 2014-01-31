class RenameFlagShowToShowInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :flag_show_name,  :show_name
    rename_column :users, :flag_show_email, :show_email
  end
end
