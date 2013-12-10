require 'spec_helper'

describe 'Voting Question' do
  let(:question) { create :question, :with_tags, title: 'Voting in democracy' }
  let(:user) { create :user }

  before :each do
    login_as question.author
  end

  context 'when does not have vote' do
    it 'voteup', js: true do
      visit question_path(question.id)

      click_link 'question-'+question.id.to_s+'-voteup'

      wait_for_remote

      expect(question).to be_upvoted_by(question.author)

      within '#question-'+question.id.to_s+'-voting' do
        expect(page).to have_content('1')
      end
    end
  end

  context 'when question have voteup' do
    before :each do
      question.toggle_voteup_by! question.author
    end

    it 'vote down', js: true do
      visit question_path(question.id)

      click_link 'question-'+question.id.to_s+'-votedown'

      wait_for_remote

      expect(question).to be_downvoted_by(question.author)

      within '#question-'+question.id.to_s+'-voting' do
        expect(page).to have_content('-1')
      end
    end

    it 'cancel vote', js: true do
      visit question_path(question.id)

      click_link 'question-'+question.id.to_s+'-voteup'

      wait_for_remote

      expect(question).not_to be_voted_by(question.author)

      within '#question-'+question.id.to_s+'-voting' do
        expect(page).to have_content('0')
      end
    end
  end

  context 'when have vote from someone else' do
    before :each do
      question.toggle_voteup_by! user
    end

    it 'voteup', js: true do
      visit question_path(question.id)

      click_link 'question-'+question.id.to_s+'-voteup'

      wait_for_remote

      within '#question-'+question.id.to_s+'-voting' do
        expect(page).to have_content('2')
      end
    end
  end
end
