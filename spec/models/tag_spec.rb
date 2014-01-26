require 'spec_helper'

describe Tag do
  describe '#normalize' do
    it 'replaces spaces with dash' do
      tag = create :tag, name: 'my tag'

      expect(tag.name).to eql(:'my-tag')
    end

    it 'correcly handles symbol' do
      tag = create :tag, name: :elasticsearch

      expect(tag.name).to eql('elasticsearch')
    end
  end
end
