require 'spec_helper'

describe Probe::Results do
  subject { described_class.new(query, &search) }

  let(:query) { { from: 0, size: 25 } }
  let(:search) { -> { response }}
  let(:response) { JSON.parse(fixture('probe/search/response.json').read) }

  describe '#response' do
    it 'return response' do
      expect(subject.response).to eql(response)
    end
  end

  describe '#results' do
    it 'returns results as objects' do
      results = subject.results

      expect(results.first.to_h).to eql(subject.response['hits']['hits'][0]['_source'].symbolize_keys)
    end

    context 'with loader' do
      it 'preprocesses records' do
        loader  = double(:loader)
        results = subject.original_results

        expect(loader).to receive(:call).with(results)

        subject.loader = loader
        subject.results
      end
    end
  end
end
