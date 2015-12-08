module Shared::NotificationsHelper
  def notifications
    Shared::Notification.where(resource_type: [Shared::Question, Shared::Answer, Shared::Comment])
  end

  def last_notification
    notifications.order(created_at: :desc).first
  end

  def reset_notifications
    Shared::Notification.delete_all
  end
end
