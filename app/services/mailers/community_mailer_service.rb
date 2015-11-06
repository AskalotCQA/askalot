module Mailers
  class CommunityMailerService
    def self.users
      User.where(send_email_notifications: true)
    end

    def self.deliver_mails!(email)
      users.each.map { |user|
        CommunityMailer.community_emails(email, user)
      }.map(&:deliver!)
    end

    def self.deliver_test_mail!(email)
      CommunityMailer.community_emails(email, email[:user]).deliver!
    end

    def self.deliver_all_emails!
      Email.where(status: false).each do |email|
        deliver_mails!(email)
        email.status = true

        email.save
      end
    end
  end
end
