module Shared::Notifications
  module Utility
    extend self

    def send_notification_email?(user)
      return (DateTime.now.to_i - user.last_mail_notification_sent_at.to_i) >= 1.day if user.send_mail_notifications_frequency == 'daily'

      newest_sent_unread_notification      = last_sent_unread_notification(user)
      seconds_since_last_sent_notification = DateTime.now.to_i - user.last_mail_notification_sent_at.to_i

      return true if newest_sent_unread_notification.nil? || seconds_since_last_sent_notification > 12.hours

      delay = user.mail_notification_delay == 0 ? 2 : user.mail_notification_delay

      seconds_since_last_sent_notification / 3600.0 >= delay.to_f
    end

    def unread_notifications(user)
      Shared::Notification.for(user).unread.where('created_at >= ?', notifications_since(user))
    end

    def last_sent_unread_notification(user)
      Shared::Notification.for(user).unread
          .where('created_at <= ?', user.last_mail_notification_sent_at)
          .order(created_at: :desc).limit(1).first
    end

    def notifications_since(user)
      user.send_mail_notifications_frequency == 'daily' ? 1.day.ago : user.last_mail_notification_sent_at
    end

    def update_last_notification_sent_at(user)
      return user.update(last_mail_notification_sent_at: Time.now) if user.send_mail_notifications_frequency == 'instantly'
      user.update(last_mail_notification_sent_at: Date.today + 5.hours) if (DateTime.now.to_i - user.last_mail_notification_sent_at.to_i) >= 1.day
    end

    def update_delay(user)
      return unless user.send_mail_notifications_frequency == 'instantly'

      newest_sent_unread_notification      = last_sent_unread_notification(user)
      seconds_since_last_sent_notification = DateTime.now.to_i - user.last_mail_notification_sent_at.to_i

      if newest_sent_unread_notification.nil? || seconds_since_last_sent_notification > 12.hours
        user.update(mail_notification_delay: 0) if user.mail_notification_delay != 0
        return
      end

      delay = user.mail_notification_delay == 0 ? 2 : user.mail_notification_delay

      user.update!(mail_notification_delay: delay * 2) if seconds_since_last_sent_notification / 3600.0 >= delay.to_f
    end
  end
end
