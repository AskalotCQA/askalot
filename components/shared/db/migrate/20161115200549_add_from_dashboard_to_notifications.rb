class AddFromDashboardToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :from_dashboard, :boolean, default: false
  end
end
