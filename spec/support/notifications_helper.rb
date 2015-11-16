module NotificationsHelper
  def notifications
    University::Notification.where(resource_type: [University::Question, University::Answer, University::Comment])
  end

  def last_notification
    notifications.order(created_at: :desc).first
  end

  def reset_notifications
    University::Notification.delete_all
  end
end
