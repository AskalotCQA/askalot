require 'spec_helper'

describe 'Editing', js: true do
  let(:user)          { create :user }
  let(:teacher)       { create :teacher }
  let!(:question)     { create :question, :with_tags, title: 'Elasticsearch prablem' }
  let!(:answer_u)     { create :answer, question: question, author: question.author }
  let!(:answer_t)     { create :answer, question: question, author: teacher }
  let!(:comment)      { create :comment, commentable: question, author: question.author }
  let(:administrator) { create :administrator }

  context 'when question have no evaluation' do
    before :each do
      login_as question.author
    end

    it 'can edit question', js: true do
      visit question_path question

      click_link "question-#{question.id}-edit-modal"

      within "#question-#{question.id}-editing" do
        fill_in 'question_title', with: 'Elasticsearch problem'
        fill_in 'question_text',  with: 'I have a problem with Elasticsearch Client in Ruby.'

        fill_in_select2 'question_tag_list', with: 'elasticsearch'
        fill_in_select2 'question_tag_list', with: 'ruby'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Otázka bola úspešne aktualizovaná.')

      within '#question-title' do
        expect(page).to have_content('Elasticsearch problem')
        expect(page).to have_content('elasticsearch')
        expect(page).to have_content('ruby')
      end

      within '#question-data' do
        expect(page).to have_content('I have a problem with Elasticsearch Client in Ruby.')
      end
    end

    it 'can edit answer', js: true do
      visit question_path question

      click_link "answer-#{answer_u.id}-edit-modal"

      within "#answer-#{answer_u.id}-editing" do
        fill_in 'answer[text]', with: 'I found solution already'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Odpoveď bola úspešne aktualizovaná.')
      expect(page).to have_content('I found solution already')
    end

    it 'can edit comment', js: true do
      visit question_path question

      click_link "comment-#{comment.id}-edit-modal"

      within "#comment-#{comment.id}-editing" do
        fill_in 'comment[text]', with: 'This is not good'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Komentár bol úspešne aktualizovaný.')
      expect(page).to have_content('This is not good')
    end
  end

  context 'when question or answer have evaluation' do
    before :each do
      Evaluation.create!(text: 'Good question', evaluator: teacher, evaluable: question, value:0)
      Evaluation.create!(text: 'Good answer', evaluator: teacher, evaluable: answer_u, value:0)
    end

    it 'user cant edit', js: true do
      login_as question.author
      visit question_path question

      expect(page).not_to have_css("#question-#{question.id}-edit-modal")
      expect(page).not_to have_css("#answer-#{answer_u.id}-edit-modal")
    end

    it 'administrator can edit', js: true do
      login_as administrator

      visit question_path question

      expect(page).to have_css("#question-#{question.id}-edit-modal")
      expect(page).to have_css("#answer-#{answer_u.id}-edit-modal")
      expect(page).to have_css("#comment-#{comment.id}-edit-modal")
    end
  end

  context 'when logged as another user' do
    before :each do
      login_as teacher
    end

    it 'cant edit', js: true do
      visit question_path question

      expect(page).not_to have_css("#question-#{question.id}-edit-modal")
      expect(page).not_to have_css("#answer-#{answer_u.id}-edit-modal")
      expect(page).not_to have_css("#comment-#{comment.id}-edit-modal")
    end
  end
end
