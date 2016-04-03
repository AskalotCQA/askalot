module Mooc::NotificationsHelper
  def unread_notifications
    @@unread_notifications ||= Shared::Notification.in_context(@context).for(current_user).unread.count
  end
end
