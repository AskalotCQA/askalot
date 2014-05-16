require 'spec_helper'
require 'models/concerns/searchable_spec'

shared_examples_for Answers::Searchable do
  it_behaves_like Searchable

  describe '.search' do
    let!(:questions) { 10.times.map { |record| create :question, :with_answers } }

    it 'searches answers by fulltext query' do
      question = create :question
      author   = create :user
      answers = []

      answers << create(:answer, question: question, author: author, text: 'First')
      answers << create(:answer, question: question, author: author, text: 'First and second')
      answers << create(:answer, question: question, author: author, text: 'First, second and third')

      results = Answer.search_by(q: 'third')

      expect(results.size).to eql(1)
      expect(results.first).to eql(answers.last)

      results = Answer.search_by(q: 'First')

      expect(results.size).to eql(3)
      expect(results.sort).to eql(answers.sort)
    end

    it 'paginates results' do
      results = Answer.search_by(q: 'Lorem')

      expect(results.size).to eql(10)

      results = Answer.search_by(q: 'Lorem', page: 0, per_page: 5)

      expect(results.size).to eql(5)
    end
  end
end
