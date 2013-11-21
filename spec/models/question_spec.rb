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

  describe '#labels' do
    context 'with no tag' do
      it 'contains only category' do
        question = create :question

        expect(question.labels.size).to eql(1)
        expect(question.labels.first).to be_a(Category)
      end
    end

    context 'with tags' do
      it 'contains category and tags' do
        create :question, tag_list: 'a, b, d'

        question = create :question, tag_list: 'a, b, c'

        expect(question.labels.size).to eql(4)
        expect(question.labels[0]).to be_a(Category)

        tags = question.labels[1..3].sort { |a, b| a.name <=> b.name }

        expect(tags[0].name).to eql('a')
        expect(tags[1].name).to eql('b')
        expect(tags[2].name).to eql('c')

        expect(tags[0].count).to eql(2)
        expect(tags[1].count).to eql(2)
        expect(tags[2].count).to eql(1)
      end
    end
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
