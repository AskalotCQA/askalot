require 'spec_helper'

describe Probe::Sanitizer do
  subject { described_class }

  describe '.sanitize_query' do
    it 'provides sanitized query' do
      expect(subject.sanitize_query('blabla')).to eql('blabla')
    end

    it 'correctly handles unmatched quotes' do
      expect(subject.sanitize_query('"matched" "unmatched')).to eql('"matched" \\"unmatched')
    end

    it 'correctly escapes special characters' do
      expect(subject.sanitize_query('&& + - : !')).to eql('\\&& \\+ \\- \\: \\!')
    end
  end
end
