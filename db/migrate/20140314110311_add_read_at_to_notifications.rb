class AddReadAtToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :read_at, :datetime
  end
end
