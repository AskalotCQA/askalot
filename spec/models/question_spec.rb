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

  it 'uses category tags' do
    category = create :category, tags: ['dbms', 'elasticsearch']

    question = create :question, category: category, tag_list: 'redis'

    expect(question.tags.pluck(:name).sort).to eql(['dbms', 'elasticsearch', 'redis'])
  end

  describe '.favored_by' do
    it 'returns questions favored by user' do
      user       = create :user
      other_user = create :user

      3.times do
        question = create :question

        question.toggle_favoring_by!(user)
      end

      2.times do
        question = create :question

        question.toggle_favoring_by!(other_user)
      end

      questions = Question.favored_by(user)

      expect(questions.size).to eql(3)

      questions.each do |question|
        expect(question.favorers.size).to eql(1)
        expect(question.favorers.first).to eql(user)
      end
    end
  end

  describe '.answered' do
    let!(:questions) { 3.times.map { create :question, :with_answers } }

    before :each do
      10.times { create :question }
    end

    it 'returns questions having at least one answer' do
      expect(Question.answered.count).to eql(3)

      Question.answered.each do |question|
        expect(questions).to include(question)
      end
    end
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

  describe '#favored_by?' do
    it 'checks the valid favorer' do
      favorer  = create :user
      question = create :question

      create :favorite, question: question, favorer: favorer

      expect(question).to be_favored_by(favorer)

      another_user = create :user

      expect(question).not_to be_favored_by(another_user)
    end
  end

  describe '#toggle_favoring_by!' do
    let(:user) { create :user }
    let(:question) { create :question }

    context 'when user is not a favorer' do
      it 'favors question' do
        question.toggle_favoring_by! user

        expect(question).to be_favored_by(user)
      end
    end

    context 'when user is a favorer' do
      it 'removes question from user favorites' do
        question.toggle_favoring_by! user
        question.toggle_favoring_by! user

        expect(question).not_to be_favored_by(user)
      end
    end
  end

  describe '#toggle_votedown_by!' do
    let(:user) { create :user }
    let(:question) { create :question }

    context 'when question is not voted' do
      it 'vote down' do
        question.toggle_votedown_by! user

        expect(question).to be_downvoted_by(user)
      end
    end

    context 'when question is voted' do
      before :each do
        question.toggle_votedown_by! user
      end

      it 'vote up' do
        question.toggle_voteup_by! user

        expect(question).to be_upvoted_by(user)
      end

      it 'cancel vote' do
        question.toggle_votedown_by! user

        expect(question).not_to be_voted_by(user)
      end
    end
  end
end
