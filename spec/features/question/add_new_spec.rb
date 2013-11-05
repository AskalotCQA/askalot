require 'spec_helper'

describe 'User Profile' do
  let(:user) { create :user }

  context 'when showing current user' do
    before :each do
      login_as user
    end

    it 'allows adding a new question' do
      visit root_path

      click_link 'Add new question'
    end

    it 'adds new question successfully' do
      visit root_path

      click_link 'Add new question'

      fill_in 'title', :with => 'Lorem ipsum title?'
      fill_in 'text', :with => 'Sample blah blah text'

      click_button 'Vložiť otázku'

      expect(page).to have_content('Vaša otázka bola úspešne vložená.')
    end

    it 'adds new question unsuccessfully with empty title' do
      visit root_path

      click_link 'Add new question'

      fill_in 'title', :with => ''
      fill_in 'text', :with => 'Sample blah blah text'

      click_button 'Vložiť otázku'

      expect(page).to have_content('Musíte vyplniť nadpis otázky!')
    end

    it 'adds new question unsuccessfully with empty title' do
      visit root_path

      click_link 'Add new question'

      fill_in 'title', :with => 'Lorem ipsum title?'
      fill_in 'text', :with => ''

      click_button 'Vložiť otázku'

      expect(page).to have_content('Musíte vyplniť znenie otázky!')
    end

  end
end