module Shared::Notifications
  module Utility
    extend self

    def send_notification_email?(user)
      return (DateTime.now.to_i - user.last_mail_notification_sent_at.to_i) >= 1.day if user.send_mail_notifications_frequency == 'daily'

      DateTime.now > user.last_mail_notification_sent_at + user.mail_notification_delay.hours
    end

    def unread_notifications(user)
      Shared::Notification.for(user).unread.where('created_at >= ?', notifications_since(user))
    end

    def notifications_since(user)
      user.send_mail_notifications_frequency == 'daily' ? 1.day.ago : user.last_mail_notification_sent_at
    end

    def update_last_notification_sent_at(user)
      return user.update(last_mail_notification_sent_at: Time.now) if user.send_mail_notifications_frequency == 'instantly'
      user.update(last_mail_notification_sent_at: Date.today + 5.hours)
    end

    def update_delay(user)
      return unless user.send_mail_notifications_frequency == 'instantly'

      unread_notifications_in_interval = Shared::Notification.for(user).unread.where('created_at >= ?', Shared::Configuration.mailer.check_unread_notifications_hours.hours.ago)

      delay_from_config = Shared::Configuration.mailer.notification_delay

      if unread_notifications_in_interval.any?
        user.update(mail_notification_delay: delay_from_config) if user.mail_notification_delay != delay_from_config
      else
        user.update(mail_notification_delay: 0) if user.mail_notification_delay != 0
      end
    end
  end
end
