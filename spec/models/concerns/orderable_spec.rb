require 'spec_helper'

shared_examples_for Shared::Orderable do
  let(:model) { described_class }
  let(:factory) { model.name.demodulize.underscore.to_sym }

  describe '.order_by' do
    it 'orders records by custom array of values' do
      records = [
        create(factory),
        create(factory),
        create(factory)
      ]

      expected = [records[1], records[2], records[0]]
      actual   = model.order_by(id: expected.map(&:id))

      expect(actual.to_a).to eql(expected.to_a)
    end
  end
end
