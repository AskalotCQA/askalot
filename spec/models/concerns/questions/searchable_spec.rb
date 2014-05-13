require 'spec_helper'
require 'models/concerns/searchable_spec'

shared_examples_for Questions::Searchable do
  it_behaves_like Searchable

  describe '.search' do
    let!(:questions) { 10.times.map { |record| create :question } }

    it 'searches questions by fulltext query' do
      questions = []

      questions << create(:question, title: 'One')
      questions << create(:question, tag_list: 'one, two')
      questions << create(:question, text: 'One Two Three')

      results = Question.search_by(q: 'Three')

      expect(results.size).to eql(1)
      expect(results.first).to eql(questions.last)

      results = Question.search_by(q: 'one')

      expect(results.size).to eql(3)
      expect(results.sort).to eql(questions.sort)
    end

    it 'paginates questions' do
      results = Question.search_by(q: 'title')

      expect(results.size).to eql(10)

      results = Question.search_by(q: 'title', page: 0, per_page: 5)

      expect(results.size).to eql(5)
    end
  end
end
