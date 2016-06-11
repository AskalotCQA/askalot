require 'spec_helper'

describe Shared::Reputation::Notifier do
  let!(:asker) { create :user }
  let!(:asker_profile) { create :reputation_profile, user: asker }
  let!(:answerer) { create :user }
  let!(:answerer_profile) { create :reputation_profile, user: answerer }
  let!(:answerer_2) { create :user }
  let!(:answerer_2_profile) { create :reputation_profile, user: answerer, probability: 1 }
  let!(:answerer_3) { create :user }
  let!(:answerer_3_profile) { create :reputation_profile, user: answerer, probability: 1 }
  let!(:user) { create :user }

  let!(:tag1) { create :tag, name: 'tag1' }
  let!(:tag2) { create :tag, name: 'tag2' }

  let!(:question)   { create :question, author: asker, tag_list: [:tag1, :tag2] }
  let!(:discussion) { create :question, :discussion, author: asker }

  describe 'a question without answers' do
    it 'does not change reputation for voting unanswered question' do
      reputation     = asker.profiles.of('reputation').first
      old_reputation = reputation.value
      vote           = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      reputation.reload
      expect(reputation.value).to eq(old_reputation)

      vote = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      reputation.reload
      expect(reputation.value).to eq(old_reputation)

      vote = question.toggle_votedown_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      reputation.reload
      expect(reputation.value).to eq(old_reputation)

      vote = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      reputation.reload
      expect(reputation.value).to eq(old_reputation)
    end
  end

  describe 'a question with an answer' do
    let!(:asker_rep) { asker.profiles.of('reputation').first }
    let!(:old_asker_rep) { asker_rep.value }
    let!(:answerer_rep) { answerer.profiles.of('reputation').first }
    let!(:old_answerer_rep) { answerer_rep.value }

    let!(:answer) { Shared::Answer.create(question: question, author: answerer, created_at: Time.now + 5.hours, text: 'Lorem') }

    it 'changes reputation upon first answer creation and deletion' do
      Shared::Reputation::Notifier.publish(:create, answerer, answer)
      asker_rep.reload
      expect(asker_rep.value).not_to eq(old_asker_rep)
      answerer_rep.reload
      expect(answerer_rep.value).not_to eq(old_answerer_rep)

      answer.mark_as_deleted_by!(answerer)
      Shared::Reputation::Notifier.publish(:delete, answerer, answer)
      asker_rep.reload
      expect(asker_rep.value).to eq(0.0)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(0.0)
    end

    it 'changes askers reputation upon voting' do
      vote                  = question.toggle_voteup_by!(user)
      asker_rep.probability = 1

      asker_rep.save

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to be > old_asker_rep

      after_voteup = asker_rep.value
      vote         = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to be < after_voteup

      old_asker_rep = asker_rep.value
      vote          = question.toggle_votedown_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to be < old_asker_rep

      vote = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to eq(after_voteup)
    end

    it 'changes answerers reputation upon voting' do
      answerer_rep.probability = 1

      answerer_rep.save

      vote = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to be > old_answerer_rep

      after_voteup = answerer_rep.value
      vote         = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to be < after_voteup

      old_answerer_rep = answerer_rep.value
      vote             = answer.toggle_votedown_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to be < after_voteup
      expect(answerer_rep.value).to be < old_answerer_rep

      vote = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(after_voteup)
    end
  end

  describe 'a question with more answers' do
    let!(:answerer_rep) { answerer.profiles.of('reputation').first }
    let!(:old_answerer_rep) { answerer_rep.value }
    let!(:answerer_2_rep) { answerer_2.profiles.of('reputation').first }
    let!(:old_answerer_2_rep) { answerer_2_rep.value }
    let!(:answerer_3_rep) { answerer_3.profiles.of('reputation').first }
    let!(:old_answerer_3_rep) { answerer_3_rep.value }

    let!(:answer) { Shared::Answer.create(question: question, author: answerer, created_at: Time.now + 5.hours, text: 'Lorem', votes_difference: 5) }
    let!(:answer_2) { Shared::Answer.create(question: question, author: answerer_2, created_at: Time.now + 5.hours, text: 'Lorem') }
    let!(:answer_3) { Shared::Answer.create(question: question, author: answerer_3, created_at: Time.now + 5.hours, text: 'Lorem') }


    it 'changes only one reputation if not changing max score' do
      answerer_2_rep.probability = 1
      answerer_2_rep.save

      vote = answer_2.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(old_answerer_rep)
      answerer_2_rep.reload
      expect(answerer_2_rep.value).to be > old_answerer_2_rep
      answerer_3_rep.reload
      expect(answerer_3_rep.value).to eq(old_answerer_3_rep)
    end

    it 'changes all answerers reputation if changing max score' do
      answerer_rep.probability   = 1
      answerer_2_rep.probability = 1
      answerer_3_rep.probability = 1

      answerer_rep.save
      answerer_2_rep.save
      answerer_3_rep.save
      answer.toggle_voteup_by!(user)

      vote = answer.toggle_voteup_by!(answerer_2)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      answerer_2_rep.reload
      answerer_3_rep.reload
      expect(answerer_rep.value).to be > old_answerer_rep
      expect(answerer_2_rep.value).to be > old_answerer_2_rep
      expect(answerer_3_rep.value).to be > old_answerer_3_rep
    end

    it 'changes all answerers reputation if changing min score' do
      answerer_rep.probability   = 1
      answerer_2_rep.probability = 1
      answerer_3_rep.probability = 1
      answer_2.votes_difference  = -1

      answer_2.save
      answerer_rep.save
      answerer_2_rep.save
      answerer_3_rep.save

      answer.toggle_votedown_by!(user)
      vote = answer.toggle_votedown_by!(answerer_2)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      answerer_2_rep.reload
      answerer_3_rep.reload
      expect(answerer_rep.value).to be < old_answerer_rep
      expect(answerer_2_rep.value).not_to eq(old_answerer_2_rep)
      expect(answerer_3_rep.value).not_to eq(old_answerer_3_rep)
    end
  end

  describe 'a discussion with an answer' do
    let!(:asker_rep) { asker.profiles.of('reputation').first }
    let!(:old_asker_rep) { asker_rep.value }
    let!(:answerer_rep) { answerer.profiles.of('reputation').first }
    let!(:old_answerer_rep) { answerer_rep.value }

    let!(:answer) { Shared::Answer.create(question: discussion, author: answerer, created_at: Time.now + 5.hours, text: 'Lorem') }

    it 'does not change reputation upon first answer creation and deletion' do
      Shared::Reputation::Notifier.publish(:create, answerer, answer)
      asker_rep.reload
      expect(asker_rep.value).to eq(old_asker_rep)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(old_answerer_rep)

      answer.mark_as_deleted_by!(answerer)
      Shared::Reputation::Notifier.publish(:delete, answerer, answer)
      asker_rep.reload
      expect(asker_rep.value).to eq(0.0)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(0.0)
    end

    it 'does not change askers reputation upon voting' do
      vote                  = question.toggle_voteup_by!(user)
      asker_rep.probability = 1

      asker_rep.save

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to eq(old_asker_rep)

      after_voteup = asker_rep.value
      vote         = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to eq(after_voteup)

      old_asker_rep = asker_rep.value
      vote          = question.toggle_votedown_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to eq(old_asker_rep)

      vote = question.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      asker_rep.reload
      expect(asker_rep.value).to eq(after_voteup)
    end

    it 'does not change answerers reputation upon voting' do
      answerer_rep.probability = 1

      answerer_rep.save

      vote = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(old_answerer_rep)

      after_voteup = answerer_rep.value
      vote         = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(after_voteup)

      old_answerer_rep = answerer_rep.value
      vote             = answer.toggle_votedown_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(after_voteup)
      expect(answerer_rep.value).to eq(old_answerer_rep)

      vote = answer.toggle_voteup_by!(user)

      Shared::Reputation::Notifier.publish(:create, :user, vote)
      answerer_rep.reload
      expect(answerer_rep.value).to eq(after_voteup)
    end
  end
end
