require 'spec_helper'

describe Mooc::Mailers::UserMailerService do
  describe '.deliver_notifications!' do
    it 'delivers notifications' do
      users = [
        create(:user, send_email_notifications: false),
        create(:user),
        create(:user)
      ]

      Timecop.freeze do
        Timecop.travel(2.days.ago) { create :notification, recipient: users[1], action: :create, resource: create(:question) }

        create :notification, recipient: users[2], action: :create, resource: create(:question)

        email = double(:email)

        Mooc::UserMailer.stub(:notifications).with(users[2], from: 1.days.ago) { email }

        expect(email).to receive(:deliver!)

        Mooc::Mailers::UserMailerService.deliver_notifications!
      end
    end
  end
end
