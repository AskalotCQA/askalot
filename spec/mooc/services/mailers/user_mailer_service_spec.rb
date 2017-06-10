require 'spec_helper'

describe Mooc::Mailers::UserMailerService do
  describe '.deliver_notifications!' do
    it 'delivers notifications' do
      users = [
        create(:mooc_user, send_email_notifications: false),
        create(:mooc_user),
        create(:mooc_user)
      ]

      Timecop.freeze do
        Timecop.travel(2.days.ago) { create :notification, recipient: users[1], action: :create, resource: create(:question) }

        create :notification, recipient: users[2], action: :create, resource: create(:question)

        email = double(:email)

        allow(Mooc::UserMailer).to receive(:notifications).with(users[2]) { email }

        expect(email).to receive(:deliver_now!)

        Mooc::Mailers::UserMailerService.deliver_notifications!
      end
    end
  end
end
