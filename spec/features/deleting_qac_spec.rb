require 'spec_helper'

describe 'Deleting QAC', js: true do
let!(:question) { create :question, :with_tags, title: 'Deleting question' }
let(:user) { create :user }
let(:administrator) { create :administrator }


  context 'when question has no coments and answers' do
    before :each do
      login_as question.author
    end

    it 'deleting question', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      click_link "question-#{question.id}-delete-modal"

      within "#question-#{question.id}-deleting" do
        click_link "question-#{question.id}-delete"
      end

      expect(page).to have_content('Otázka bola úspešne zmazaná.')

      expect(page.current_path).to eql(questions_path)
    end
  end

  context 'when question has answer and answer has no comments' do
    let!(:answer) { create :answer, question: question }

    before :each do
      login_as answer.author
    end
    it 'deleting answer', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      click_link "answer-#{answer.id}-delete-modal"

      within "#answer-#{answer.id}-deleting" do
        click_link "answer-#{answer.id}-delete"
      end

      expect(page).to have_content('Odpoveď bola úspešne zmazaná.')

      expect(page.current_path).to eql(question_path question)
    end
  end

  context 'when question has answer and answer has comment' do
    let!(:answer) { create :answer, question: question }
    let!(:comment_answer) { create :comment, commentable: answer, author: user }
    let!(:comment_question) { create :comment, commentable: question, author: user }

    before :each do
      login_as user
    end
    it 'deleting answer comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      click_link "comment-#{comment_answer.id}-delete-modal"

      within "#comment-#{comment_answer.id}-deleting" do
        click_link "comment-#{comment_answer.id}-delete"
      end

      expect(page).to have_content('Komentár bol úspešne zmazaný.')

      expect(page.current_path).to eql(question_path question)
    end

    it 'deleting question comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      click_link "comment-#{comment_question.id}-delete-modal"

      within "#comment-#{comment_question.id}-deleting" do
        click_link "comment-#{comment_question.id}-delete"
      end

      expect(page).to have_content('Komentár bol úspešne zmazaný.')

      expect(page.current_path).to eql(question_path question)
    end
  end

  context 'when question has answer and answer has comment and user is question author and have not permission' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as question.author
    end
    it 'not delete question', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'not delete answer', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'not delete comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer and answer has comment and user is answer author and have not permission' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as answer.author
    end
    it 'not delete question', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'not delete answer', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'not delete comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer and answer has comment and user have not permission' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as user
    end
    it 'not delete question', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'not delete answer', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'not delete comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer and answer has comment and user is administrator' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as administrator
    end
    it 'can delete question', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).to have_css("#question-#{question.id}-delete-modal")
    end

    it 'can delete answer', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'can delete comment', js: true do
      visit root_path

      click_link "Otázky"

      click_link question.title

      expect(page).to have_css("#comment-#{comment.id}-delete-modal")
    end
  end
end
