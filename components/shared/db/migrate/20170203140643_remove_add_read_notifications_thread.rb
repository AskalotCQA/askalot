class RemoveAddReadNotificationsThread < ActiveRecord::Migration
  def up
    remove_column :users, :read_notifications_thread
  end

  def down
    add_column :users, :read_notifications_thread, :boolean, default: true, null: false
  end
end
