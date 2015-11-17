module University::Mailers
  class CommunityMailerService
    def self.users
      University::User.where(send_email_notifications: true)
    end

    def self.deliver_emails!(email)
      users.each.map { |user|
        University::CommunityMailer.community_emails(email, user)
      }.map(&:deliver!)
    end

    def self.deliver_test_email!(email)
      University::CommunityMailer.community_emails(email, email[:user]).deliver!
    end

    def self.deliver_all_emails!
      University::Email.where(status: false).each do |email|
        deliver_emails!(email)
        email.status = true

        email.save
      end
    end
  end
end
