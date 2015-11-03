require 'spec_helper'

describe CommunityMailer do
  describe '.community_emails' do
    it 'sends community emails' do
      user = create :user

      mail = CommunityMailer.community_emails('[telo mailu]', '[predmet]', user)

      expect(mail.subject).to eql('[predmet]')
      expect(mail.body.encoded).to include('[telo mailu]')
    end
  end
end
