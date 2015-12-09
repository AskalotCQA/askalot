require 'spec_helper'

describe 'Deleting', type: :feature do
  let!(:question)     { create :question, :with_tags, title: 'Deleting question' }
  let(:user)          { create :user }
  let(:administrator) { create :administrator }

  context 'when question has no comments and answers', js: true do
    before :each do
      login_as question.author
    end

    it 'can delete question' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      click_link "question-#{question.id}-delete-modal"

      within "#question-#{question.id}-deleting" do
        click_button 'Zmazať'
      end

      expect(page).to have_content('Otázka bola úspešne zmazaná.')

      expect(page.current_path).to eql(questions_path)

      question.reload

      expect(question).to be_deleted
    end
  end

  context 'when question has answer without comments', js: true do
    let!(:answer) { create :answer, question: question }

    before :each do
      login_as answer.author
    end

    it 'can delete answer' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      click_link "answer-#{answer.id}-delete-modal"

      within "#answer-#{answer.id}-deleting" do
        click_button 'Zmazať'
      end

      expect(page).to have_content('Odpoveď bola úspešne zmazaná.')

      expect(page.current_path).to eql(question_path question)

      answer.reload

      expect(answer).to be_deleted
    end
  end

  context 'when question has answer with comment', js: true do
    let!(:answer) { create :answer, question: question }
    let!(:answer_comment) { create :comment, commentable: answer, author: user }
    let!(:question_comment) { create :comment, commentable: question, author: user }

    before :each do
      login_as user
    end

    it 'can delete answer comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      click_link "comment-#{answer_comment.id}-delete-modal"

      within "#comment-#{answer_comment.id}-deleting" do
        click_button 'Zmazať'
      end

      expect(page).to have_content('Komentár bol úspešne zmazaný.')

      expect(page.current_path).to eql(question_path question)

      answer_comment.reload

      expect(answer_comment).to be_deleted
    end

    it 'can delete question comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      click_link "comment-#{question_comment.id}-delete-modal"

      within "#comment-#{question_comment.id}-deleting" do
        click_button 'Zmazať'
      end

      expect(page).to have_content('Komentár bol úspešne zmazaný.')
      expect(page.current_path).to eql(question_path question)
    end
  end

  context 'when question has answer with comments and user is question author' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as question.author
    end

    it 'does not delete the question' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'does not delete the answer' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'does not delete the comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer with comments and user is answer author' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as answer.author
    end

    it 'does not delete the question' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'does not delete the answer' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'does not delete the comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer with comments and user does not have permissions' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as user
    end

    it 'does not delete the question' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-delete-modal")
    end

    it 'does not delete the answer' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'does not delete the comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#comment-#{comment.id}-delete-modal")
    end
  end

  context 'when question has answer with comments and user is administrator' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }

    before :each do
      login_as administrator
    end

    it 'can delete question' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).to have_css("#question-#{question.id}-delete-modal")
    end

    it 'can delete answer' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).to have_css("#answer-#{answer.id}-delete-modal")
    end

    it 'can delete comment' do
      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).to have_css("#comment-#{comment.id}-delete-modal")
    end
  end
end
