require 'spec_helper'

require_relative 'concerns/editable'
require_relative 'concerns/deletable'
require_relative 'concerns/orderable'
require_relative 'concerns/searchable'
require_relative 'concerns/taggable'
require_relative 'concerns/touchable'
require_relative 'concerns/watchable'
require_relative 'concerns/questions/searchable'

describe Shared::Question, type: :model do
  it_behaves_like Shared::Editable
  it_behaves_like Shared::Deletable
  it_behaves_like Shared::Orderable
  it_behaves_like Shared::Taggable
  it_behaves_like Shared::Touchable
  it_behaves_like Shared::Watchable

  it_behaves_like Shared::Questions::Searchable do
    let(:attribute) { :text }
  end

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

  context 'deleted' do
    it 'does not have any undeleted answers' do
      question = create :question, :with_answers

      question.mark_as_deleted_by! question.author

      expect(question.answers.deleted.count).to eql(3)
      expect(question.answers.undeleted.count).to eql(0)
    end

    it 'does not have any undeleted taggings' do
      category = create :category, tags: ['nosql', 'elasticsearch']
      question = create :question, category: category

      question.mark_as_deleted_by! question.author

      expect(question.taggings.deleted.count).to eql(2)
      expect(question.taggings.undeleted.count).to eql(0)

      question = create :question, category: category, tag_list: 'redis, cassandra'

      question.mark_as_deleted_by! question.author

      expect(question.taggings.deleted.count).to eql(4)
      expect(question.taggings.undeleted.count).to eql(0)
    end
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

      questions = Shared::Question.favored_by(user)

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
      expect(Shared::Question.answered.count).to eql(3)

      Shared::Question.answered.each do |question|
        expect(questions).to include(question)
      end
    end
  end

  describe '#labels' do
    context 'with no tag' do
      it 'contains only category and no tag' do
        question = create :question

        expect(question.labels.size).to eql(1)
        expect(question.labels.first).to be_a(Shared::Category)
      end
    end

    context 'with tags' do
      it 'contains category and tags' do
        create :question, tag_list: 'a, b, d'

        question = create :question, tag_list: 'a, b, c'

        expect(question.labels.size).to eql(4)
        expect(question.labels[0]).to be_a(Shared::Category)

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
      it 'votes down' do
        question.toggle_votedown_by! user

        expect(question).to be_downvoted_by(user)
      end
    end

    context 'when question is already voted' do
      before :each do
        question.toggle_votedown_by! user
      end

      it 'votes up' do
        question.toggle_voteup_by! user

        expect(question).to be_upvoted_by(user)
      end

      it 'cancels vote' do
        question.toggle_votedown_by! user

        expect(question).not_to be_voted_by(user)
      end
    end
  end

  describe Shared::Touchable do
    it 'does not update questions touched_at attribute when voting, viewing or labeling' do
      question      = create :question
      old_timestamp = question.touched_at
      user          = create :user

      Timecop.travel(Time.now + 100) do
        question.toggle_voteup_by! user
        question.votes_count += 1
        question.votes_difference += 1
        question.votes_lb_wsci_bp += 1
        question.views_count += 1
        question.toggle_favoring_by! user
      end

      expect(question.touched_at).to eql(old_timestamp)
    end
  end
end
