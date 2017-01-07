module Mooc::Mailers
  class UserMailerService
    def self.users
      Mooc::User.where(send_email_notifications: true)
    end

    def self.deliver_notifications!
      users.joins(:notifications).where('notifications.created_at >= ?', 1.day.ago).uniq.find_each.map { |user|
        Mooc::UserMailer.notifications(user, from: 1.day.ago)
      }.map(&:deliver_now!)
    end
  end
end
