class UpdateNamesOfUserColumns < ActiveRecord::Migration
  def change
    rename_column :favorites, :user_id, :favorer_id
    rename_column :views,     :user_id, :viewer_id
  end
end
