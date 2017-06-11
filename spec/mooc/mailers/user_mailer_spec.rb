require 'spec_helper'

describe Mooc::UserMailer, type: :mailer do
  describe '.notifications' do
    before :each do
      @context  = 1
      @category = Shared::Category.find(@context).leaves.first

      user2 = create :mooc_user, last_mail_notification_sent_at: 1.day.ago

      @question1 = create :question, :with_tags, author: user2, category: @category
      @question2 = create :question, :with_tags, author: user2, category: @category
    end

    context 'when has daily notifications' do
      it 'sends notifications summary for day' do
        Timecop.freeze(Time.utc(2014, 03, 18)) do
          user = create :mooc_user, last_mail_notification_sent_at: 1.day.ago

          Timecop.travel(2.days.ago) { create :notification, recipient: user, action: :create, resource: @question1, context: @context }

          create :notification, recipient: user, action: :create, resource: @question2, context: @context

          since = Shared::Notifications::Utility.notifications_since(user)

          expect(since).to eql(1.day.ago)

          mail = Mooc::UserMailer.notifications(user)

          expect(mail.subject).to eql('[Askalot] Nové notifikácie')
          expect(mail.body.encoded).to include('Pridanie otázky')
          expect(mail.body.encoded).to include('18. Marec 2014')
          expect(mail.body.encoded).not_to include('16. Marec 2014')
        end
      end


      it 'sends only once per day' do
        Timecop.freeze(Time.utc(2014, 03, 18)) do
          user = create :user, last_mail_notification_sent_at: 12.hours.ago

          create :notification, recipient: user, action: :create, resource: @question2, context: @context

          since = Shared::Notifications::Utility.notifications_since(user)

          expect(since).to eql(1.day.ago)
          expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_falsey

          mail = Mooc::UserMailer.notifications(user)

          expect(mail.subject).to be_nil
          expect(mail.message.class).to be(ActionMailer::Base::NullMail)
        end
      end

      context 'when user has not notifications' do
        it 'does not deliver email' do
          user = create :mooc_user

          mail = Mooc::UserMailer.notifications(user)

          expect(mail.subject).to be_nil
          expect(mail.message.class).to be(ActionMailer::Base::NullMail)
        end
      end
    end

    context 'when has instant notifications' do
      it 'sends email instantly' do
        Timecop.freeze(Time.utc(2014, 03, 18)) do
          user = create :mooc_user, last_mail_notification_sent_at: 12.hours.ago, send_mail_notifications_frequency: 'instantly'

          create :notification, recipient: user, action: :create, resource: @question2, context: @context

          since = Shared::Notifications::Utility.notifications_since(user)

          expect(since).to eql(12.hours.ago)

          mail = Mooc::UserMailer.notifications(user)

          expect(mail.subject).to eql('[Askalot] Nové notifikácie')
          expect(mail.body.encoded).to include('Pridanie otázky')
          expect(mail.body.encoded).to include('18. Marec 2014')
          expect(mail.body.encoded).not_to include('Tieto notifikácie sme Vám poslali s oneskorením')
        end
      end

      it 'delays email if previous notification was not read' do
        Timecop.freeze(Time.utc(2014, 03, 18)) do
          user = create :mooc_user, last_mail_notification_sent_at: 12.hours.ago, send_mail_notifications_frequency: 'instantly'

          create :notification, recipient: user, action: :create, resource: @question2, context: @context

          since = Shared::Notifications::Utility.notifications_since(user)

          expect(since).to eql(12.hours.ago)

          expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_truthy

          mail = Mooc::UserMailer.notifications(user)

          expect(mail.subject).to eql('[Askalot] Nové notifikácie')
          expect(mail.body.encoded).to include('Pridanie otázky')
          expect(mail.body.encoded).to include('18. Marec 2014')
          expect(mail.body.encoded).not_to include('Tieto notifikácie sme Vám poslali s oneskorením')

          expect(user.last_mail_notification_sent_at).to eq(Time.now)

          Timecop.travel(10.minutes.from_now) do
            create :notification, recipient: user, action: :create, resource: @question2, context: @context

            since = Shared::Notifications::Utility.notifications_since(user)

            expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_falsey

            mail = Mooc::UserMailer.notifications(user)
            expect(since).to eql(Time.utc(2014, 03, 18))

            expect(mail.subject).to be_nil
            expect(mail.message.class).to be(ActionMailer::Base::NullMail)
          end

          Timecop.travel(70.minutes.from_now) do
            create :notification, recipient: user, action: :create, resource: @question2, context: @context

            since = Shared::Notifications::Utility.notifications_since(user)

            expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_falsey

            mail = Mooc::UserMailer.notifications(user)
            expect(since).to eql(Time.utc(2014, 03, 18))

            expect(mail.subject).to be_nil
            expect(mail.message.class).to be(ActionMailer::Base::NullMail)
          end

          Timecop.travel(370.minutes.from_now) do
            create :notification, recipient: user, action: :create, resource: @question2, context: @context

            expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_truthy

            mail = Mooc::UserMailer.notifications(user)

            expect(mail.subject).to eql('[Askalot] Nové notifikácie')
            expect(mail.body.encoded).to include('Tieto notifikácie sme Vám poslali s oneskorením')
          end

          Timecop.travel(480.minutes.from_now) do
            create :notification, recipient: user, action: :create, resource: @question2, context: @context

            expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_falsey

            mail = Mooc::UserMailer.notifications(user)

            expect(mail.subject).to be_nil
          end

          Timecop.travel(16.hours.from_now) do
            create :notification, recipient: user, action: :create, resource: @question2, context: @context

            expect(Shared::Notifications::Utility.send_notification_email?(user)).to be_truthy

            mail = Mooc::UserMailer.notifications(user)

            expect(mail.subject).to eql('[Askalot] Nové notifikácie')
            expect(mail.body.encoded).to include('Tieto notifikácie sme Vám poslali s oneskorením')
          end
        end
      end
    end
  end
end
