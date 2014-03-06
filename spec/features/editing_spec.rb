require 'spec_helper'

describe 'Editing', js: true do
  let!(:question)     { create :question, :with_tags, title: 'Editing question' }
  let(:user)          { create :user }
  let(:administrator) { create :administrator }

  context 'when question have no evaluation' do
    before :each do
      login_as question.author
    end

    it 'can edit question', js: true do
      visit question_path question

      click_link "question-#{question.id}-edit-modal"

      within "#question-#{question.id}-edit" do
        fill_in 'question_title', with: 'Titulok otazky'
        fill_in 'question_text', with: 'text otazky'
        #fill_in_select2 'question_tag_list', with: 'prvy'
        #fill_in_select2 'question_tag_list', with: 'druhy'

        click_link 'Uložiť'
      end

      expect(page).to have_content('Vaša otázka bola úspešne aktualizovaná ')
    end
  end

end
