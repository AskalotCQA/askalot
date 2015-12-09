require 'spec_helper'

describe 'Closing', type: :feature do
  let!(:question)     { create :question, :with_tags, title: 'Closing question' }
  let(:user)          { create :user }
  let(:administrator) { create :administrator }

  context 'when question has no answers', js: true do
    it 'does not close a question as user' do
      login_as user

      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end

    it 'closes a question as administrator' do
      login_as administrator

      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      click_link "question-#{question.id}-close-modal"

      within "#question-#{question.id}-closing" do
        click_button 'Uzavrieť'
      end

      expect(page).to have_content('Otázka bola úspešne uzatvorená.')
      expect(page.current_path).to eql(questions_path)

      question.reload

      expect(question).to be_closed

      visit shared.root_path

      click_link 'Otázky'

      expect(page).to have_content(question.title)

      click_link 'Bez odpovede'

      expect(page).not_to have_content(question.title)
    end
  end

  context 'when question has answer', js: true do
    let!(:answer) { create :answer, question: question }

    it 'does not close a question as adminitrator' do
      login_as administrator

      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end

    it 'does not close a question as user' do
      login_as user

      visit shared.root_path

      click_link 'Otázky'

      click_link question.title

      expect(page).not_to have_css("#question-#{question.id}-close-modal")
    end
  end
end
