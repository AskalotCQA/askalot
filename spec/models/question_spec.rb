require 'spec_helper'

describe Question do
  it 'requires title' do
    question = build :question, title: ''

    expect(question).not_to be_valid

    question = build :question, title: 'My title'

    expect(question).to be_valid
  end

  it 'requires text' do
    question = build :question, text: nil

    expect(question).not_to be_valid

    question = build :question, text: 'Text'

    expect(question).to be_valid
  end

  describe '#favoured_by?' do
    it 'checks the valid favourer' do
      user     = create :user
      question = create :question

      create :favorite, question: question, user: user

      expect(question).to be_favoured_by(user)

      another_user = create :user

      expect(question).not_to be_favoured_by(another_user)
    end
  end

  describe '#favour_by!' do
    let(:user) { create :user }
    let(:question) { create :question }

    context 'when user is not a favourer' do
      it 'favours question' do
        question.favour_by! user

        expect(question).to be_favoured_by(user)
      end
    end

    context 'when user is a favourer' do
      it 'removes question from user favorites' do
        question.favour_by! user
        question.favour_by! user

        expect(question).not_to be_favoured_by(user)
      end
    end
  end
end
