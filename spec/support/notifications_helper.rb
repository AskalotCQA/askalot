module NotificationsHelper
  def notifications
    Notification.where(resource_type: [Question, Answer, Comment])
  end

  def last_notification
    notifications.order(created_at: :desc).first
  end

  def reset_notifications
    Notification.delete_all
  end
end
