require 'spec_helper'

describe 'Add News', type: :feature do
  context 'when logged in as administrator' do
    let(:administrator)   { create :administrator}
    let(:news)            { create :news}

    before :each do
      login_as administrator
    end

    it 'adds new news and show on homepage' do
      visit shared.root_path

      click_link 'Administrácia', match: :first
      click_link 'Novinky', match: :first

      fill_in 'news[title]', with: 'Test news'
      fill_in 'news[description]', with: 'News'
      check 'Zobraziť na domovskej stránke'
      date = Date.today.strftime('%-d. %-m. %Y')

      click_button 'Pridať novinku'

      expect(page).to have_content('Novinka bola úspešne pridaná.')

      within '.administration-changelogs' do
        expect(page).to have_content('Test news')
      end

      visit shared.root_path

      within '#news' do
        expect(page).to have_content('Test news')
        expect(page).to have_content(date)
        expect(page).to have_content('News')
      end

      click_link 'Odhlásiť', match: :first

      visit shared.root_path

      within '.news' do
        expect(page).to have_content('Test news')
        expect(page).to have_content(date)
        expect(page).to have_content('News')
      end
    end
  end
end
