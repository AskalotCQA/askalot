module Mailers
  class CommunityMailerService
    def self.users
      User.where(send_email_notifications: true)
    end

    def self.deliver_mails!(body, subject, send_html_email=false)
      users.each.map { |user|
        CommunityMailer.community_emails(body, subject, user, send_html_email)
      }.map(&:deliver!)
    end

    def self.deliver_test_mail!(body, subject, current_user, send_html_email=false)
      CommunityMailer.community_emails(body, subject, current_user, send_html_email).deliver!
    end
  end
end
