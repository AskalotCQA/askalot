require 'spec_helper'

describe 'Add Question' do
  let(:user) { create :user }

  context 'with current user' do
    before :each do
      login_as user
    end

    it 'adds new question' do
      visit root_path

      click_link 'Pridať novú otázku'

      fill_in 'question_title', with: ''
      fill_in 'question_text',  with: ''

      expect(page).to have_content('Nadpis – je povinná položka')
      expect(page).to have_content('Text – je povinná položka')

      fill_in 'question_title', with: 'Lorem ipsum title?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Vlož otázku'

      expect(page).to have_content('Vaša otázka bola úspešne vložená.')
    end
  end
end
