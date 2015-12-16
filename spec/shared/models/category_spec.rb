require 'spec_helper'
require_relative 'concerns/watchable_spec'

describe Shared::Category, type: :model do
  it_behaves_like Shared::Watchable

  it 'requires name' do
    category = build :category, name: ''

    expect(category).not_to be_valid

    category = build :category, name: 'Category'

    expect(category).to be_valid
  end

  it 'has unique name' do
    create :category, name: 'Category'

    category = build :category, name: 'Category'

    expect(category).not_to be_valid
  end

  describe '#count' do
    let(:category) { create :category }

    context 'with no questions' do
      it 'has zero count' do
        expect(category.count).to be_zero
      end
    end

    context 'with multiple questions' do

      it 'has count more than zero' do
        3.times { create :question, category: category }

        expect(category.count).to eql(3)
      end
    end

    context 'with deleted questions' do

      it 'ommits deleted questions for count' do
        4.times { create :question, category: category }
        2.times { create :question, :deleted, category: category }

        expect(category.count).to eql(4)
      end
    end
  end

  describe '#question_counts' do
    let(:category) { create :category, uuid: 'category' }

    context 'with no questions' do
      it 'has zero direct questions' do
        expect(category.direct_questions_count).to be_zero
      end

      it 'has zero direct shared questions' do
        expect(category.direct_shared_questions_count).to be_zero
      end
    end

    context 'with three direct questions' do
      it 'has three direct questions' do
        3.times { create :question, category: category }

        expect(category.direct_questions_count).to eql(3)
        expect(category.direct_shared_questions_count).to eql(3)
      end
    end

    context 'with three indirect questions' do
      it 'has three shared questions' do
        version = create :category, uuid: 'category'
        outer = create :category

        3.times { create :question, category: version }

        expect(category.direct_questions_count).to be_zero
        expect(version.direct_questions_count).to eql(3)
        expect(category.direct_shared_questions_count).to eql(3)
        expect(version.direct_shared_questions_count).to eql(3)
        expect(outer.direct_questions_count).to be_zero
        expect(outer.direct_shared_questions_count).to be_zero
      end
    end
  end

  describe '#answer_counts' do
    let(:shared1) { create :category, uuid: 'category' }
    let(:shared2) { create :category, uuid: 'category' }
    let(:outer) { create :category }
    let(:sh1q1) { create :question, category: shared1 }
    let(:sh1q2) { create :question, category: shared1 }
    let(:sh2q) { create :question, category: shared2 }
    let(:qouter_question) { create :question, category: outer }

    context 'with no answer' do
      it 'has no answers' do
        expect(shared1.direct_answers_count).to be_zero
        expect(shared2.direct_answers_count).to be_zero
        expect(outer.direct_answers_count).to be_zero
        expect(shared1.direct_shared_answers_count).to be_zero
        expect(shared2.direct_shared_answers_count).to be_zero
        expect(outer.direct_shared_answers_count).to be_zero
      end
    end

    context 'one category with three questions on category one' do
      it 'has three answers on one category in two questions and other has one' do
        2.times { create :answer, question: sh1q1 }

        create :answer, question: sh1q2
        create :answer, question: sh2q

        shared1.reload
        shared2.reload
        expect(shared1.direct_answers_count).to eql(3)
        expect(shared1.direct_shared_answers_count).to eql(3)
        expect(shared2.direct_answers_count).to eql(1)
        expect(shared2.direct_shared_answers_count).to eql(4)
        expect(outer.direct_shared_answers_count).to be_zero
        expect(category.direct_shared_questions_count).to be_zero
      end
    end

    context 'with three indirect questions' do
      it 'has three shared questions' do
        version = create :category, uuid: 'category'
        outer = create :category
        3.times { create :question, category: version }

        expect(category.direct_questions_count).to be_zero
        expect(version.direct_questions_count).to eql(3)
        expect(category.direct_shared_questions_count).to eql(3)
        expect(version.direct_shared_questions_count).to eql(3)
        expect(outer.direct_questions_count).to be_zero
        expect(outer.direct_shared_questions_count).to be_zero
      end
    end
  end

  describe '.with_slido' do
    it 'finds only categories with slido username' do
      create :category

      question = create :category, :with_slido

      questions = Shared::Category.with_slido

      expect(questions.size).to eql(1)
      expect(questions).to      include(question)
    end
  end
end
