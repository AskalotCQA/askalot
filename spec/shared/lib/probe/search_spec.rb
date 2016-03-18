require 'spec_helper'
require 'shared/probe'
require 'shared/probe/search'

describe Shared::Probe::Search do
  subject { probe }

  let(:probe) { document.probe }
  let(:index) { probe.index }
  let(:document) { Class.new(OpenStruct) { include Shared::Probe } }

  before :each do
    index.name = :test
    index.type = :document

    index.delete

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

    index.create

    index.mapper.define id: -> { id }, title: -> { title.downcase }

    documents = [document.new(id: 1, title: 'Westside'), document.new(id: 2, title: 'Eastside')]

    index.import(documents)
  end

  after :each do
    index.delete
  end

  describe '#search' do
    it 'search documents with simple query' do
      results = subject.search query: {
        query_string: {
          query: 'westside',
          default_field: :title
        }
      }

      expect(results.size).to        eql(1)
      expect(results.first.title).to eql('westside')
    end
  end
end
