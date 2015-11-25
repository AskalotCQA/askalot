require 'spec_helper'

shared_examples_for Shared::Questions::Searchable do
  it_behaves_like Shared::Searchable

  let(:questions) { 10.times.map { |record| create :question } }

  before :each do
    Shared::Question.autoimport = true

    Shared::Question.probe.index.reload do
      questions
    end
  end

  describe '.search' do
    it 'searches questions by fulltext query' do
      questions = []

      questions << create(:question, title: 'One')
      questions << create(:question, tag_list: 'one, two')
      questions << create(:question, text: 'One Two Three')

      results = Shared::Question.search_by(q: 'Three')

      expect(results.size).to eql(1)
      expect(results.first).to eql(questions.last)

      results = Shared::Question.search_by(q: 'one')

      expect(results.size).to eql(3)
      expect(results.sort).to eql(questions.sort)
    end
  end
end
