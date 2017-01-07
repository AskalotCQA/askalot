require 'spec_helper'

describe University::UserMailer, type: :mailer do
  describe '.notifications' do
    it 'sends notifications summary for day' do
      user = create :user

      Timecop.freeze(Time.utc(2014, 03, 18)) do
        Timecop.travel(2.days.ago) { create :notification, recipient: user, action: :create, resource: create(:question) }

        create :notification, recipient: user, action: :create, resource: create(:question)

        mail = University::UserMailer.notifications(user, from: 1.day.ago)

        expect(mail.subject).to eql('[Askalot] Nové notifikácie')
        expect(mail.body.encoded).to include('Pridanie otázky')
        expect(mail.body.encoded).to include('18. Marec 2014')
        expect(mail.body.encoded).not_to include('16. Marec 2014')
      end
    end

    context 'when user has not notifications' do
      it 'does not deliver email' do
        user = create :user

        mail = University::UserMailer.notifications(user, from: 1.day.ago)

        expect(mail.subject).to be_nil
        expect(mail.message.class).to be(ActionMailer::Base::NullMail)
      end
    end
  end
end
