class ChangeContextFormatInNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :context
    add_column :notifications, :context, :integer
  end
end
