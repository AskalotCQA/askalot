module Shared::Mailers
  class CommunityMailerService
    def self.users
      Shared::User.where(send_email_notifications: true)
    end

    def self.deliver_emails!(email)
      users.each.map { |user|
        Shared::CommunityMailer.community_emails(email, user)
      }.map(&:deliver_now!)
    end

    def self.deliver_test_email!(email)
      Shared::CommunityMailer.community_emails(email, email[:user]).deliver_now!
    end

    def self.deliver_all_emails!
      Shared::Email.where(status: false).each do |email|
        deliver_emails!(email)
        email.status = true

        email.save
      end
    end
  end
end
