require 'spec_helper'

describe 'Editing', type: :feature do
  let(:author)          { create :user }
  let(:user)            { create :user }
  let(:user2)           { create :user }
  let(:teacher)         { create :teacher }
  let!(:question)       { create :question, :with_tags, author: author, title: 'Elasticsearch prablem', created_at: Time.now - 10.minutes }
  let!(:answer_user)    { create :answer, question: question, author: question.author, created_at: Time.now - 10.minutes  }
  let!(:answer_teacher) { create :answer, question: question, author: teacher, created_at: Time.now - 10.minutes  }
  let!(:answer_user2)   { create :answer, question: question, author: user2, created_at: Time.now - 10.minutes  }
  let!(:comment)        { create :comment, commentable: question, author: question.author, created_at: Time.now - 10.minutes  }
  let(:administrator)   { create :administrator }

  context 'when question has no evaluation' do
    before :each do
      login_as question.author
    end

    it 'can edit question', js: true do
      visit shared.question_path question

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
      visit shared.question_path question

      click_link "answer-#{answer_user.id}-edit-modal"

      within "#answer-#{answer_user.id}-editing" do
        fill_in 'answer[text]', with: 'I found solution already'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Odpoveď bola úspešne aktualizovaná.')
      expect(page).to have_content('I found solution already')
    end

    it 'can edit comment', js: true do
      visit shared.question_path question

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
      Shared::Evaluation.create!(text: 'Good question', author: teacher, evaluable: question, value:0)
      Shared::Evaluation.create!(text: 'Good answer', author: teacher, evaluable: answer_user, value:0)
    end

    it 'user cannot edit' do
      login_as question.author
      visit shared.question_path question

      expect(page).not_to have_css("#question-#{question.id}-edit-modal")
      expect(page).not_to have_css("#answer-#{answer_user.id}-edit-modal")
    end

    it 'administrator can edit' do
      login_as administrator

      visit shared.question_path question

      expect(page).to have_css("#question-#{question.id}-edit-modal")
      expect(page).to have_css("#answer-#{answer_user.id}-edit-modal")
      expect(page).to have_css("#answer-#{answer_teacher.id}-edit-modal")
      expect(page).to have_css("#comment-#{comment.id}-edit-modal")
    end
  end

  context 'when logged as another user' do
    before :each do
      login_as user2
    end

    it 'cant edit' do
      visit shared.question_path question

      expect(page).not_to have_css("#question-#{question.id}-edit-modal")
      expect(page).not_to have_css("#answer-#{answer_user.id}-edit-modal")
      expect(page).to have_css("#answer-#{answer_user2.id}-edit-modal")
      expect(page).not_to have_css("#comment-#{comment.id}-edit-modal")
    end
  end

  context 'when edit question category' do
    let(:user_watcher)    { create :user }
    let!(:category)       { create :category, name: 'Ostatné' }
    let!(:watching)       { create :watching, watcher: user_watcher, watchable: category }

    it 'sends notification to new watchers' do
      question.update(created_at: Time.now - 10.minutes)

      login_as question.author

      visit shared.question_path question

      click_link "question-#{question.id}-edit-modal"

      within "#question-#{question.id}-editing" do
        select category.name, from: 'question_category_id'
        click_button 'Uložiť'
      end

      click_link 'Odhlásiť', match: :first

      login_as user_watcher

      visit shared.root_path

      click_link 'Zobraziť viac'

      within "#unread" do
        expect(page).to have_content("Upravenie otázky #{question.title}")
      end
    end
  end
end
