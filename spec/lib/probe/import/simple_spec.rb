require 'spec_helper'
require 'shared/probe/import/simple'

describe Shared::Probe::Import::Simple do
  describe '#import' do
    it 'imports documents one by one' do
      client    = double(:client)
      index     = double(:index, name: 'test', type: 'type', client: client)
      documents = [
        double(:document, id: 1, to_mapping: { id: 1 }),
        double(:document, id: 2, to_mapping: { id: 2 }),
      ]

      expect(client).to receive(:index).with(index: 'test', type: 'type', id: 1, body: { id: 1 })
      expect(client).to receive(:index).with(index: 'test', type: 'type', id: 2, body: { id: 2 })

      Shared::Probe::Import::Simple.new(index, documents).import
    end
  end
end
