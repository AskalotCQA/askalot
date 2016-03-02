class ChangeContextFormatInNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :context
    add_column :notifications, :context, :integer
  end

  def down
    remove_column :notifications, :context
    add_column :notifications, :context, :string
  end
end
