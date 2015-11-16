require 'spec_helper'

describe University::Mailers::CommunityMailerService do

  describe '.deliver_mails!' do

    before :each do
      create(:user, send_email_notifications: false)
      create(:user)
      create(:user)
      create(:user, send_email_notifications: false)
      create(:user, send_email_notifications: false)
      create(:user)
      create(:user)
      create(:user, send_email_notifications: false)
    end

    it 'delivers community emails' do
      expect { University::Mailers::CommunityMailerService.deliver_emails!({ body: '[telo mailu]', subject: '[predmet]', send_html_email: false }) }.to change { ActionMailer::Base.deliveries.count }.by(5)
    end

    it 'delivers test community email' do
      user = create(:user)
      expect { University::Mailers::CommunityMailerService.deliver_test_email!({ body: '[telo mailu]', subject: '[predmet]', send_html_email: false, user: user }) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
