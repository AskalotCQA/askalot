class AddReadNotificationsThread < ActiveRecord::Migration
  def change
    add_column :users, :read_notifications_thread, :boolean, default: true, null: false
  end
end
