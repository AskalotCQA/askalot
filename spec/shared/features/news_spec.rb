require 'spec_helper'

describe 'News', type: :feature do
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

      within '.news-well' do
        expect(page).to have_content('Test news')
        expect(page).to have_content(date)
        expect(page).to have_content('News')
      end

      click_link 'Odhlásiť', match: :first

      visit shared.root_path

      within '.home-news' do
        expect(page).to have_content('Test news')
        expect(page).to have_content(date)
        expect(page).to have_content('News')
      end
    end

    it 'updates news', js: true do
      news = create :news

      visit shared.administration_news_index_path

      # the test in chromedriver is somewhat broken because animated elements
      # so the solution is to remove fading animation
      #
      # https://github.com/teamcapybara/capybara/issues/1890
      # https://bugs.chromium.org/p/chromedriver/issues/detail?id=1771&q=sendkeys&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
      page.driver.browser.execute_script("$('.fade').removeClass('fade')")

      find(:css, "a#news-#{news.id}-edit-modal").click

      within "#news-#{news.id}-editing" do
        fill_in 'news[title]', with: 'Something else'
        fill_in 'news[description]', with: 'This is something else'

        click_button 'Uložiť'
      end

      expect(page).to have_content('Novinka bola úspešne aktualizovaná.')

      news.reload

      expect(news.title).to eql('Something else')
      expect(news.description).to eql('This is something else')
    end
  end
end
