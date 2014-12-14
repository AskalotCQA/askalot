require 'spec_helper'

describe Probe::Index do
  let(:index) { Probe::Index.new(name: :test, type: :document) }

  before :each do
    index.settings = {
      index: {
        number_of_shards: 1,
        number_of_replicas: 0
      }
    }

    index.mappings = {
      document: {
        properties: {
          doc: {
            properties: {
              id: {
                type: :integer
              },
              text: {
                type: :string
              }
            }
          }
        }
      }
    }
  end

  after :each do
    index.delete
  end

  describe '#create' do
    it 'creates index' do
      index.create

      expect(index.exists?).to be_truthy
    end
  end

  describe '#delete' do
    it 'deletes index' do
      index.create

      index.delete

      expect(index.exists?).to be_falsey
    end
  end

  describe '#import' do
    let(:document) { Class.new(OpenStruct) { include Probe } }

    before :each do
      document.probe.index = index
    end

    it 'imports documents' do
      documents = [document.new(id: 1, title: 'Westside')]

      index.mapper.define id:    -> { id }
      index.mapper.define title: -> { title.downcase }

      index.import(documents)

      expect(index.size).to eql(1)
    end
  end
end
