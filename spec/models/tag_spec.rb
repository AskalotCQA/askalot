require 'spec_helper'
require 'models/concerns/watchable_spec'

describe Tag do
  it_behaves_like Watchable

  describe '#normalize' do
    it 'replaces spaces with dash' do
      tag = create :tag, name: 'my tag'

      expect(tag.name).to eql('my-tag')
    end

    it 'correcly handles symbol' do
      tag = create :tag, name: :elasticsearch

      expect(tag.name).to eql('elasticsearch')
    end
  end

  describe '#count' do
    before :each do
      3.times { create :question, tag_list: 'doge' }
      2.times { create :question, tag_list: 'wow' }
    end

    it 'provides count by taggings' do
      tag = Tag.find_by name: 'doge'

      expect(tag.count).to eql(3)

      tag = Tag.find_by name: 'wow'

      expect(tag.count).to eql(2)
    end

    context 'when taggable model is deleted' do
      it 'ommits couting relation' do
        tag       = Tag.find_by name: 'doge'
        questions = Question.tagged_with('doge')

        expect(tag.count).to eql(questions.count)

        questions.first.mark_as_deleted_by! questions.first.author

        tag = Tag.find_by name: 'doge'

        expect(tag.count).to eql(2)
      end
    end
  end
end
