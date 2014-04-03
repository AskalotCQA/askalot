require 'spec_helper'

shared_examples_for Searchable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }

  describe '.search' do
    it 'searches records' do
      records = 10.times.map { |record| create factory }

      results = model.search

      expect(results.sort).to eql(records)
    end
  end
end
