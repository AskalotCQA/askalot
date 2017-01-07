require 'spec_helper'

describe Mooc::UserMailer, type: :mailer do
  describe '.notifications' do
    it 'sends notifications summary for day' do
      user = create :mooc_user
      user2 = create :mooc_user

      @context  = 1
      @category = Shared::Category.find(@context).leaves.first

      Timecop.freeze(Time.utc(2014, 03, 18)) do
        question1 = create :question, :with_tags, author: user2, category: @category
        question2 = create :question, :with_tags, author: user2, category: @category

        Timecop.travel(2.days.ago) { create :notification, recipient: user, action: :create, resource: question1, context: @context }

        create :notification, recipient: user, action: :create, resource: question2, context: @context

        mail = Mooc::UserMailer.notifications(user, from: 1.day.ago)

        expect(mail.subject).to eql('[Askalot] Nové notifikácie')
        expect(mail.body.encoded).to include('Pridanie otázky')
        expect(mail.body.encoded).to include('18. Marec 2014')
        expect(mail.body.encoded).not_to include('16. Marec 2014')
      end
    end

    context 'when user has not notifications' do
      it 'does not deliver email' do
        user = create :mooc_user

        mail = Mooc::UserMailer.notifications(user, from: 1.day.ago)

        expect(mail.subject).to be_nil
        expect(mail.message.class).to be(ActionMailer::Base::NullMail)
      end
    end
  end
end
