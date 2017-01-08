require 'spec_helper'

# TODO (smolnar) resolve notice messages after signing in and signing out

describe 'Authentication', type: :feature do
  let(:user) { create :user, password: 'password' }

  context 'when not registered' do
    it 'does not sign in user successfully' do
      allow(Shared::Stuba::AIS).to receive(:authenticate).and_return(nil)

      visit shared.root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'bogus'
      fill_in 'user_password', with: 'bogus'

      click_button 'Prihlásiť'

      expect(page).to have_content('Nesprávne prihlasovacie údaje.')
    end
  end

  context 'when registered' do
    it 'signs in user successfully' do
      allow(Shared::Stuba::AIS).to receive(:authenticate).and_return(nil)

      visit shared.root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      #expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content(user.nick)

      within :css, '.navbar-right li .dropdown-menu' do
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

      visit shared.root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      #expect(page).to have_content('Úspešne prihlásený.')

      expect { click_button 'Prihlásiť' }.to change { Shared::User.count }.by(1)

      expect(page).to have_content(user.login)
    end
  end
end
