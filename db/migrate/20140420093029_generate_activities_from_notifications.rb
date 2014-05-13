class GenerateActivitiesFromNotifications < ActiveRecord::Migration
  def up
    Notification.find_each do |notification|
      activity = Activity.find_or_initialize_by action: notification.action, initiator: notification.initiator, resource: notification.resource

      activity.created_at = activity.created_on = notification.created_at

      activity.save!
    end
  end
end
