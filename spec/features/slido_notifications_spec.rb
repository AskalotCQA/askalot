require 'spec_helper'

describe 'Slido Notifications' do
  let(:user) { create :user }

  before :each do
    login_as user
  end

  it 'shows notifications about current slido events' do
    create :slido_event, name: 'Westside Party #3', url: 'https://sli.do/ali.g/wp03'

    visit root_path

    click_link 'Otázky'

    within '#flash' do
      expect(page).to have_content('Aktuálne prebieha Westside Party #3 https://sli.do/ali.g/wp03')
    end
  end

  context 'when automaticly refreshing', js: true do
    it 'shows new notiticaitons about current events' do
      visit root_path

      click_link 'Otázky'

      expect(page).not_to have_css('#flash')

      create :slido_event, name: 'Westside Party #3', url: 'https://sli.do/ali.g/wp03'

      wait_for_remote 6.seconds

      within '#flash' do
        expect(page).to have_content('Aktuálne prebieha Westside Party #3 https://sli.do/ali.g/wp03')
      end
    end
  end
end
