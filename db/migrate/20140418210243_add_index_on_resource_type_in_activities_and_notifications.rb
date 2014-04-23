class AddIndexOnResourceTypeInActivitiesAndNotifications < ActiveRecord::Migration
  def change
    add_index :activities,    :resource_type
    add_index :notifications, :resource_type
  end
end
