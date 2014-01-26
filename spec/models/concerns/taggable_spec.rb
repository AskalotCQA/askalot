require 'spec_helper'

shared_examples_for Taggable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }


  describe '#tag_list' do
    it 'assignes tags from string' do
      record = model.new

      record.tag_list = 'a, b, c'

      expect(record.tag_list.tags).to eql(['a', 'b', 'c'])
    end

    context 'when no tags assigned' do
      it 'provides empty list' do
        record = model.new

        expect(record.tag_list.tags).to be_empty
      end
    end
  end

  describe '.tagged_with' do
    context 'with a tag name' do
      it 'searches records tagged by the tag' do
        create factory, tag_list: 'a, b'

        4.times { create factory, tag_list: 'a, b, c' }

        records = model.tagged_with('c')

        expect(records.size).to eql(4)

        records.each { |record| expect(record.tags.pluck(:name)).to include('c') }
      end
    end

    context 'with multiple tags' do
      it 'searches records tagged by those tags' do
        create factory, tag_list: 'a, b'
        create factory, tag_list: 'a, c'
        create factory, tag_list: 'a, c, d'

        4.times { create factory, tag_list: 'a, b, c' }

        records = model.tagged_with('a, c')

        expect(records.size).to eql(6)

        records.each do |record|
          expect(record.tags.pluck(:name)).to include('a')
          expect(record.tags.pluck(:name)).to include('c')
        end
      end
    end
  end

  context 'after saving' do
    it 'generates tags' do
      record = build factory

      record.tag_list = 'a, b, c'

      record.save!

      expect(record.tags.order(:name).pluck(:name)).to eql(['a', 'b', 'c'])
    end
  end
end

describe Taggable::TagList do
  let(:extractor) { double(:extractor) }

  describe '#+' do
    it 'appends tags to list' do
      list = Taggable::TagList.new(nil, 'a, b')

      list.extractor = extractor

      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])
      expect(extractor).to receive(:extract).with('c, d').and_return(['c', 'd'])

      expect(list.tags).to eql(['a', 'b'])

      list += 'c, d'

      expect(list).to eql(['a', 'b', 'c', 'd'])
    end
  end

  describe '#each' do
    it 'iterates over tags' do
      list = Taggable::TagList.new(nil, 'a, b')

      list.extractor = extractor

      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])

      list.each { |value| expect(['a', 'b']).to include(value) }
    end
  end

  describe '#tags' do
    it 'extract tags' do
      list = Taggable::TagList.new(nil, 'a, b')

      list.extractor = extractor

      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])

      expect(list.tags).to eql(['a', 'b'])
    end

    context 'when using configuration' do
      it 'extract tags by custom extractor' do
        base = double(:base, extractor: extractor)
        list = Taggable::TagList.new(base, 'a b')

        expect(base).to receive(:extractor?).and_return(true)
        expect(extractor).to receive(:extract).with('a b').and_return(['a', 'b'])

        expect(list.tags).to eql(['a', 'b'])
      end
    end
  end
end

describe Taggable::TagList::Extractor do
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
