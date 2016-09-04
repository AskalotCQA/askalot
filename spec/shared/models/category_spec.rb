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

  describe '#save_assignments' do
    let!(:category) { create :category, name: 'Context Category', parent: nil }
    let!(:teacher) { create :teacher }

    it 'copies assignments from parent category' do
      expect(category.assignments.count).to eql(0)

      create :assignment, user: teacher, category: category, role: Shared::Role.find_by(name: :teacher)

      expect(category.assignments.count).to eql(1)

      new_category = create :category, parent: category

      expect(new_category.assignments.count).to eql(1)
    end
  end

  describe 'when copying a category' do
    let!(:category_a) { create :category, name: 'A', parent: nil }
    let!(:category_b) { create :category, name: 'B', parent: category_a }
    let!(:category_c) { create :category, name: 'C', parent: category_b }
    let!(:category_d) { create :category, name: 'D', parent: nil }

    it 'copies category with no specified parent id' do
      expect(category_b.parent_id).to eql(category_a.id)

      category_b_copy = category_b.copy(category_d, nil)

      expect(category_b_copy.parent_id).to eql(category_d.id)
      expect(category_b_copy.full_tree_name).to eql('D - B')
    end

    it 'copies category with specified parent id' do
      category_a_copy = category_a.copy(category_d, nil)
      expect(category_a_copy.parent_id).to eql(category_d.id)
      expect(category_a_copy.full_tree_name).to eql('D - A')

      category_b_copy = category_b.copy(category_d, category_a_copy.id)
      expect(category_b_copy.parent_id).to eql(category_a_copy.id)
      expect(category_b_copy.full_tree_name).to eql('D - A - B')
    end

    describe 'copy associations' do
      let!(:teacher) { create :teacher }
      let!(:student) { create :student }
      let!(:category_e) { create :category, name: 'E', parent: category_a }
      let!(:watching) { create :watching, watcher: teacher, watchable: category_e }
      let!(:watching2) { create :watching, watcher: student, watchable: category_e }

      it 'always copies associated watchings for teachers' do
        expect(category_e.watchings.count).to eql(2)

        copy = category_e.copy(category_a, nil)
        expect(copy.parent_id).to eql(category_a.id)
        expect(copy.full_tree_name).to eql('A - E')
        expect(copy.watchings.count).to eql(1)
      end

      it 'copies associated watching if the category is "Všeobecné"' do
        expect(category_e.watchings.count).to eql(2)

        category_e.update_attributes(name: 'Všeobecné')

        copy = category_e.copy(category_a, nil)
        expect(copy.parent_id).to eql(category_a.id)
        expect(copy.full_tree_name).to eql('A - Všeobecné')
        expect(copy.watchings.count).to eql(2)
      end

      it 'copies associated assignments' do
        create :assignment, user: student, category: category_e, role: Shared::Role.find_by(name: :teacher)

        expect(category_e.assignments.count).to eql(1)

        copy = category_e.copy(category_a, nil)

        expect(copy.parent_id).to eql(category_a.id)
        expect(copy.full_tree_name).to eql('A - E')
        expect(copy.assignments.count).to eql(1)
      end
    end
  end
end
