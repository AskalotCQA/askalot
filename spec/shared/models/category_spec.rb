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

  describe 'check tree names' do
    let!(:a) { create :category, name: 'A', parent: nil }
    let!(:b) { create :category, name: 'B', parent: a }
    let!(:c) { create :category, name: 'C', parent: b }
    let!(:d) { create :category, name: 'D', parent: nil }

    it 'updates full tree names' do
      expect(a.full_tree_name).to eql('A')
      expect(b.full_tree_name).to eql('A - B')
      expect(c.full_tree_name).to eql('A - B - C')

      b.name = 'BB'

      b.save
      a.reload
      b.reload
      c.reload

      expect(a.full_tree_name).to eql('A')
      expect(b.full_tree_name).to eql('A - BB')
      expect(c.full_tree_name).to eql('A - BB - C')

      b.parent_id = d.id

      b.save
      a.reload
      b.reload
      c.reload

      expect(a.full_tree_name).to eql('A')
      expect(b.full_tree_name).to eql('D - BB')
      expect(c.full_tree_name).to eql('D - BB - C')
    end
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

  describe '#answer_counts' do
    let!(:shared1) { create :category, uuid: 'category' }
    let!(:shared2) { create :category, uuid: 'category' }
    let!(:outer) { create :category }
    let!(:sh1q1) { create :question, category: shared1 }
    let!(:sh1q2) { create :question, category: shared1 }
    let!(:sh2q) { create :question, category: shared2 }
    let!(:outer_question) { create :question, category: outer }

    context 'with no answer' do
      it 'has no answers' do
        expect(shared1.related_answers.count).to be_zero
        expect(shared2.related_answers.count).to be_zero
        expect(outer.related_answers.count).to be_zero
      end
    end

    context 'one category with three questions on category one' do
      it 'has three answers on one category in two questions and other has one' do
        2.times { create :answer, question: sh1q1 }

        create :answer, question: sh1q2
        create :answer, question: sh2q

        shared1.reload
        shared2.reload

        expect(shared1.answers.count).to eql(3)
        expect(shared1.related_answers.count).to eql(4)
        expect(shared2.answers.count).to eql(1)
        expect(shared2.related_answers.count).to eql(4)
        expect(outer.related_answers.count).to be_zero
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

  describe 'copy category' do
    let!(:a) { create :category, name: 'A', parent: nil }
    let!(:b) { create :category, name: 'B', parent: a }
    let!(:c) { create :category, name: 'C', parent: b }
    let!(:d) { create :category, name: 'D', parent: nil }

    it 'copy category with no specified parent id' do
      expect(b.parent_id).to eql(a.id)

      b_copy = b.copy(d,nil)

      expect(b_copy.parent_id).to eql(d.id)
      expect(b_copy.full_tree_name).to eql('D - B')
    end

    it 'copy category with specified parent id' do
      a_copy = a.copy(d,nil)
      expect(a_copy.parent_id).to eql(d.id)
      expect(a_copy.full_tree_name).to eql('D - A')

      b_copy = b.copy(d,a_copy.id)
      expect(b_copy.parent_id).to eql(a_copy.id)
      expect(b_copy.full_tree_name).to eql('D - A - B')
    end
  end
end
