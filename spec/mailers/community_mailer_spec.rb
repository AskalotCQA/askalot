require 'spec_helper'

describe CommunityMailer do
  describe '.community_emails' do
    it 'sends community emails' do
      user = create :user

      mail = CommunityMailer.community_emails({ body: '[telo mailu]', subject: '[predmet]', send_html_email: false }, user)

      expect(mail.subject).to eql('[predmet]')
      expect(mail.body.encoded).to include('[telo mailu]')
    end
  end
end
