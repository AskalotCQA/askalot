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
          id: {
            type: :integer
          },
          text: {
            type: :string
          }
        }
      }
    }
  end

  after :all do
    index.delete
  end

  describe '#create' do
    it 'creates index' do
      index.create

      expect(index.exists?).to be_true
    end
  end

  describe '#delete' do
    it 'deletes index' do
      index.create

      index.delete

      expect(index.exists?).to be_false
    end
  end

  describe '#import' do
    it 'imports documents' do
      documents = [OpenStruct.new(title: 'Westside')]

      index.mapper.define title: -> { title.downcase }

      index.import(documents)

      # TODO (smolnar) check if indexed
    end
  end
end
