require 'spec_helper'

describe Shared::CategoryQuestion, type: :model do

  it 'is creates question cache when question with category is created' do
    category = create :category
    create :question, category: category

    expect(Shared::CategoryQuestion.all.count).to eql(4)
    expect(Shared::CategoryQuestion.where(category_id: category.id).count).to eql(1)
    expect(Shared::CategoryQuestion.where(category_id: category.parent_id).count).to eql(1)
  end

  describe '#delete' do
    let(:category) { create :category }
    let(:question) { create :question }
    let(:question_category) { create :category_question, question_id: question.id, category_id: category.id }
    let(:user) { create :user }

    context 'deleting category' do
      it 'deletes question cache when category is deleted' do
        expect(Shared::CategoryQuestion.exists?(question_category.id)).to be_truthy

        category.destroy

        expect(Shared::CategoryQuestion.exists?(question_category.id)).to be_falsey
      end
    end

    context 'deleting question' do
      it 'deletes question cache question is deleted by user' do
        expect(Shared::CategoryQuestion.exists?(question_category.id)).to be_truthy

        question.mark_as_deleted_by! user

        expect(Shared::CategoryQuestion.exists?(question_category.id)).to be_falsey
      end
    end
  end

  describe '#change_category_sharing' do
    let!(:category) { create :category, uuid: 'category', shared: true }
    let!(:category_shared) { create :category, uuid: 'category', shared: true }
    let!(:category_unshared) { create :category, uuid: 'category', shared: false }
    let!(:question) { create :question, category: category }

    context 'creating question for shared categories' do
      it 'creates question cache for shared category' do
        category.reload
        category_shared.reload
        category_unshared.reload
        question.reload

        expect(category.category_questions.count).to eql(1)
        expect(category_shared.category_questions.count).to eql(1)
        expect(category_unshared.category_questions.count).to eql(0)
        expect(question.category_questions.count).to eql(8)
      end
    end

    context 'unshare category' do
      it 'removes question cache for unshared category' do
        category_shared.shared = false
        category_shared.save!

        category.reload
        question.reload
        category_shared.reload
        category_unshared.reload

        expect(category.category_questions.count).to eql(1)
        expect(category_shared.category_questions.count).to eql(0)
        expect(category_unshared.category_questions.count).to eql(0)
        expect(question.category_questions.count).to eql(4)
      end
    end

    context 'share category' do
      it 'creates question cache for shared category' do
        category_unshared.shared = true
        category_unshared.save!

        category.reload
        question.reload
        category_shared.reload
        category_unshared.reload

        expect(category.category_questions.count).to eql(1)
        expect(category_shared.category_questions.count).to eql(1)
        expect(category_unshared.category_questions.count).to eql(1)
        expect(question.category_questions.count).to eql(12)
      end
    end
  end
end
