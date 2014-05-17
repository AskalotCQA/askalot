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

      answers << create(:answer, question: question, author: author, text: 'One')
      answers << create(:answer, question: question, author: author, text: 'One, two')
      answers << create(:answer, question: question, author: author, text: 'One, two, three')

      results = Answer.search_by(q: 'three')

      expect(results.size).to eql(1)
      expect(results.first).to eql(answers.last)

      results = Answer.search_by(q: 'One')

      expect(results.size).to eql(3)
      expect(results.sort).to eql(answers.sort)
    end
  end
end
