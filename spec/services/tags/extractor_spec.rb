require 'spec_helper'

describe University::Tags::Extractor do
  let(:extractor) { described_class }

  describe '.extract' do
    it 'extracts tags from string' do
      values = 'a, b, c '

      expect(extractor.extract(values)).to eql(['a', 'b', 'c'])
    end

    it 'extract tags from array' do
      values = ['a', :b, ' c']

      expect(extractor.extract(values)).to eql(['a', 'b', 'c'])
    end
  end
end
