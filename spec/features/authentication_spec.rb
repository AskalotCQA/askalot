require 'spec_helper'

describe 'Authentication' do
  let(:user) { create :user, password: 'password' }

  context 'when not registered' do
    it 'does not sign in user successfully' do
      Stuba::AIS.stub(:authenticate) { nil }

      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'bogus'
      fill_in 'user_password', with: 'bogus'

      click_button 'Prihlásiť'

      expect(page).to have_content('Nesprávne prihlasovacie údaje.')
    end
  end

  context 'when registered' do
    it 'signs in user successfully' do
      Stuba::AIS.stub(:authenticate) { nil }

      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      #expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content(user.nick)

      within :css, 'ul li .dropdown-menu' do
        click_link 'Odhlásiť'
      end

      #expect(page).to have_content('Úspešne odhlásený.')
      expect(page).not_to have_content(user.nick)
    end
  end

  context 'with AIS credentials' do
    it 'signs up user' do
      user = build :user, :as_ais

      stub_ais_for user

      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      #expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content(user.login)
      #expect(page).to have_content(user.email)

      expect(User).to have(1).record
    end
  end
end
