require 'spec_helper'

describe 'Deleting QAC', js: true do
let(:question) { create :question, :with_tags, title: 'Deleting question' }
let(:question_with_answer) { create :question, :with_tags, title: 'Deleting answer' }
let!(:answer) { create :answer, question: question_with_answer }
let(:user) { create :user }



  context 'when question has no coments and answers' do
    before :each do
      login_as question.author
    end

    it 'deleting question', js: true do
      visit question_path(question.id)

      click_link "question-#{question.id}-delete-modal"

      within "#question-#{question.id}-deleting" do
        click_link "question-#{question.id}-delete"
      end

      expect(page).to have_content('Otázka bola úspešne zmazaná.')
    end
  end

  context 'when question has answers and answer has no comments' do
    before :each do
      login_as answer.author
    end
    it 'deleting answer', js: true do
      visit question_path(question_with_answer.id)

      click_link "answer-#{answer.id}-delete-modal"

      within "#answer-#{answer.id}-deleting" do
        click_link "answer-#{answer.id}-delete"
      end

      expect(page).to have_content('Odpoveď bola úspešne zmazaná.')
    end
  end

end


