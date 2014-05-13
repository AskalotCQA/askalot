class AddAnonymousFlagToActivityAndNotification < ActiveRecord::Migration
  def change
    add_column :activities,    :anonymous, :boolean, null: false, default: false
    add_column :notifications, :anonymous, :boolean, null: false, default: false
  end
end
