require 'spec_helper'

describe Category do
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
  end

  describe '.with_slido' do
    it 'finds only categories with slido username' do
      create :category

      question = create :category, :with_slido

      questions = Category.with_slido

      expect(questions.size).to eql(1)
      expect(questions).to      include(question)
    end
  end
end
