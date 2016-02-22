require 'spec_helper'

describe Shared::CategoryQuestion, type: :model do

  it 'is created when question with category is created' do
    category = create :category
    create :question, category: category

    expect(Shared::CategoryQuestion.all.count).to eql(3)
    expect(Shared::CategoryQuestion.where(category_id: category.id).count).to eql(1)
    expect(Shared::CategoryQuestion.where(category_id: category.parent_id).count).to eql(1)
  end

  describe '#insert_delete' do
    let(:category) { create :category }
    let(:question) { create :question }
    let(:question_category) { create :category_question, question_id: question.id, category_id: category.id }

    context 'deleting category' do
      it 'is deleted when category is deleted' do
        expect(Shared::CategoryQuestion.exists?(question_category)).to be_truthy

        category.destroy

        expect(Shared::CategoryQuestion.exists?(question_category)).to be_falsey
      end
    end

    context 'deleting question' do
      it 'is deleted when question is deleted' do
        expect(Shared::CategoryQuestion.exists?(question_category)).to be_truthy

        question.destroy

        expect(Shared::CategoryQuestion.exists?(question_category)).to be_falsey
      end
    end
  end
end
