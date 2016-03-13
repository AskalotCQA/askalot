require 'spec_helper'

describe Shared::CommunityMailer, type: :mailer do
  describe '.community_emails' do
    it 'sends community emails' do
      user = create :user

      mail = Shared::CommunityMailer.community_emails({ body: '[telo mailu]', subject: '[predmet]', send_html_email: false }, user)

      expect(mail.subject).to eql('[predmet]')
      expect(mail.body.encoded).to include('[telo mailu]')
    end
  end
end
