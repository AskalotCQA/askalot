class RenameNotifiableToResourceInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :notifiable_id,   :resource_id
    rename_column :notifications, :notifiable_type, :resource_type
  end
end
