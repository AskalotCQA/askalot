require 'spec_helper'

describe Mailers::CommunityMailerService do

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
      expect { Mailers::CommunityMailerService.deliver_mails!('body','test') }.to change { ActionMailer::Base.deliveries.count }.by(5)
    end

    it 'delivers test community email' do
      user = create(:user)
      expect { Mailers::CommunityMailerService.deliver_test_mail!('body','test', user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
