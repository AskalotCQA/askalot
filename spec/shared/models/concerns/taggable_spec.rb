require 'spec_helper'

shared_examples_for Shared::Taggable do
  let(:model) { described_class }
  let(:factory) { model.name.demodulize.underscore.to_sym }

  describe '#tag_list' do
    it 'assignes tags from string' do
      record = build factory

      record.tag_list = 'a, b, c'

      expect(record.tag_list.tags).to eql(['a', 'b', 'c'])
      expect(record.tags.pluck(:name)).to be_empty
    end

    it 'loads tag list with existing tags' do
      record = build factory

      record.tag_list = 'a, b'

      record.save!

      expect(record.tag_list.tags.sort).to     eql(['a', 'b'])
      expect(record.tags.pluck(:name).sort).to eql([ 'a', 'b'])

      record = model.find(record.id)

      expect(record.tag_list.tags.sort).to     eql(['a', 'b'])
      expect(record.tags.pluck(:name).sort).to eql(['a', 'b'])
    end

    context 'when no tags assigned' do
      it 'provides empty list' do
        record = model.new

        expect(record.tag_list.tags).to be_empty
      end
    end

    context 'when tag list changes' do
      it 'changes record' do
        record = create factory, tag_list: 'a, b, c'

        record.tag_list = 'c, d'

        expect(record).to be_changed
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
    it 'create tags' do
      record = create factory, tag_list: 'a, b, c'

      expect(record.tags.order(:name).pluck(:name)).to eql(['a', 'b', 'c'])
    end

    context 'when tag list changes' do
      it 'removes unused tagging relations' do
        record = create factory, tag_list: 'a, b, c'

        expect(record.tags.order(:name).pluck(:name)).to eql(['a', 'b', 'c'])

        record.tag_list = 'a, b'

        record.save!

        expect(record.tags.order(:name).pluck(:name)).to eql(['a', 'b'])
      end
    end

    context 'when tag list is empty' do
      it 'removes all taggings' do
        record = create factory, tag_list: 'a, b, c'

        record.tag_list = nil

        record.save!

        expect(record.tags).to be_empty
      end
    end
  end
end

describe Shared::Taggable::TagList do
  let(:extractor) { double(:extractor) }

  describe '#+' do
    it 'appends tags to list' do
      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])
      expect(extractor).to receive(:extract).with('c, d').and_return(['c', 'd'])

      list = Shared::Taggable::TagList.new(extractor, 'a, b')

      expect(list.tags).to eql(['a', 'b'])

      list += 'c, d'

      expect(list).to eql(['a', 'b', 'c', 'd'])
    end
  end

  describe '#each' do
    it 'iterates over tags' do
      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])

      list = Shared::Taggable::TagList.new(extractor, 'a, b')

      list.each { |value| expect(['a', 'b']).to include(value) }
    end
  end

  describe '#tags' do
    it 'extract tags' do
      expect(extractor).to receive(:extract).with('a, b').and_return(['a', 'b'])

      list = Shared::Taggable::TagList.new(extractor, 'a, b')

      expect(list.tags).to eql(['a', 'b'])
    end
  end
end
