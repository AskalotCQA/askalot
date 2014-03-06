require 'spec_helper'

describe 'Editing', js: true do
  let!(:question)     { create :question, :with_tags, title: 'Elasticsearch prablem' }
  let(:user)          { create :user }
  let(:administrator) { create :administrator }

  context 'when question have no evaluation' do
    before :each do
      login_as question.author
    end

    it 'can edit question', js: true do
      visit root_path

      click_link question.title

      click_link "question-#{question.id}-edit-modal"

      within "#question-#{question.id}-edit" do
        fill_in 'question_title', with: 'Elasticsearch problem'
        fill_in 'question_text',  with: 'I have a problem with Elasticsearch Client in Ruby.'

        fill_in_select2 'question_tag_list', with: 'elasticsearch'
        fill_in_select2 'question_tag_list', with: 'ruby'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Vaša otázka bola úspešne aktualizovaná.')

      within '#question-title' do
        expect(page).to have_content('Elasticsearch problem')
      end

      within '#question-data' do
        expect(page).to have_content('elasticseach')
        expect(page).to have_content('ruby')
        expect(page).to have_content('I have a problem with Elasticsearch Client in Ruby.')
      end
    end
  end
end
