require 'spec_helper'

describe 'Slido Notifications' do
  let(:category) { create :category }
  let(:user) { create :user }

  before :each do
    login_as user
  end

  it 'shows notifications about current slido events' do
    create :slido_event, category: category, name: 'Westside Party #3', url: 'https://sli.do/ali.g/wp03'

    visit root_path

    click_link 'Otázky'

    within '#flash' do
      expect(page).to have_content('Aktuálne prebieha prednáška Westside Party #3, ak máte záujem spýtať sa otázku použite sli.do na adrese https://sli.do/ali.g/wp03.')
    end
  end

  context 'when automaticly refreshing', js: true do
    it 'shows new notiticaitons about current events' do
      Configuration.poll.true = 1

      visit root_path

      click_link 'Otázky'

      expect(page).not_to have_css('#flash')

      create :slido_event, category: category, name: 'Westside Party #3', url: 'https://sli.do/ali.g/wp03'

      wait_for_remote 2.seconds

      within '#flash' do
        expect(page).to have_content('Aktuálne prebieha prednáška Westside Party #3, ak máte záujem spýtať sa otázku použite sli.do na adrese https://sli.do/ali.g/wp03.')
      end

      Configuration.poll.true = 60
    end
  end
end
