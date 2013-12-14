require 'spec_helper'

describe 'Voting Question', js: true do
  let(:question) { create :question, :with_tags, title: 'Voting in democracy' }
  let(:user) { create :user }

  before :each do
    login_as question.author
  end

  context 'when question has no votes' do
    it 'votes up', js: true do
      visit question_path(question.id)

      click_link "question-#{question.id}-voteup"

      wait_for_remote

      expect(question).to be_upvoted_by(question.author)

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('1')
      end
    end

    it 'votes down' do
      visit question_path(question.id)

      click_link "question-#{question.id}-votedown"

      wait_for_remote

      expect(question).to be_downvoted_by(question.author)

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('-1')
      end
    end
  end

  context 'when question have been already voted up' do
    before :each do
      question.toggle_voteup_by! question.author
    end

    it 'votes down' do
      visit question_path(question.id)

      click_link "question-#{question.id}-votedown"

      wait_for_remote

      expect(question).to be_downvoted_by(question.author)

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('-1')
      end
    end

    it 'cancels vote' do
      visit question_path(question.id)

      click_link "question-#{question.id}-voteup"

      wait_for_remote

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('0')
      end
    end
  end

  context 'when voted by someone else' do
    before :each do
      question.toggle_voteup_by! user
    end

    it 'votes up' do
      visit question_path(question.id)

      click_link "question-#{question.id}-voteup"

      wait_for_remote

      expect(question).to be_upvoted_by(question.author)

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('2')
      end
    end

    it 'votes down' do
      visit question_path(question.id)

      click_link "question-#{question.id}-votedown"

      wait_for_remote

      expect(question).to be_downvoted_by(question.author)

      within "#question-#{question.id}-voting" do
        expect(page).to have_content('0')
      end
    end
  end
end
