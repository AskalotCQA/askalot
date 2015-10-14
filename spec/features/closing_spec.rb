require 'spec_helper'

describe 'Closing' do
  let!(:question)     { create :question, :with_tags, title: 'Closing question' }
  let(:user)          { create :user }
  let(:administrator) { create :administrator }

  context 'when question has no answers', js: true do
    it 'administrator close a question' do
      login_as administrator

      visit root_path

      click_link 'Otázky'

      click_link question.title

      click_link "question-#{question.id}-close-modal"

      within "#question-#{question.id}-closig" do
        click_button 'Uzavrieť'
      end

      expect(page).to have_content('Otázka bola úspešne uzatvorená.')

      expect(page.current_path).to eql(questions_path)

      question.reload

      expect(question).to be_closed
    end

    it 'user does not close a question' do
      login_as user

      visit root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end
  end

  context 'when question has answer', js: true do
    let!(:answer) { create :answer, question: question }

    it 'administrator does not close a question' do
      login_as administrator

      visit root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end

    it 'user does not close a question' do
      login_as user

      visit root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end
  end
end
