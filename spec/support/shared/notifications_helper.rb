module Shared::NotificationsHelper
  def notifications
    Shared::Notification.all
  end

  def last_notification
    notifications.order(created_at: :desc).first
  end

  def reset_notifications
    Shared::Notification.delete_all
  end
end
