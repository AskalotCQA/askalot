require 'spec_helper'

describe Probe::Import::Bulk do
  describe '#import' do
    it 'imports documents in batches' do
      client    = double(:client)
      index     = double(:index, name: 'test', type: 'type', client: client)
      documents = [
        double(:document, id: 1, to_mapping: { id: 1 }),
        double(:document, id: 2, to_mapping: { id: 2 }),
        double(:document, id: 3, to_mapping: { id: 3 }),
        double(:document, id: 4, to_mapping: { id: 4 }),
      ]

      expect(client).to receive(:bulk).with(body: [
        { index: { _index: 'test', _type: 'type', _id: 1 }},
        { doc: { id: 1 }},
        { index: { _index: 'test', _type: 'type', _id: 2 }},
        { doc: { id: 2 }}
      ])

      expect(client).to receive(:bulk).with(body: [
        { index: { _index: 'test', _type: 'type', _id: 3 }},
        { doc: { id: 3 }},
        { index: { _index: 'test', _type: 'type', _id: 4 }},
        { doc: { id: 4 }}
      ])

      Probe::Import::Bulk.new(index, documents, batch_size: 2).import
    end
  end
end
