require 'spec_helper'

describe 'User Authentication' do
  let(:user) { create :user, password: 'password' }

  context 'when registered' do
    it 'signs in user successfully' do
      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content("Prihlásený ako #{user.login}")

      click_link 'Odhlásiť'

      expect(page).to have_content('Úspešne odhlásený.')
    end
  end

  context 'when using AIS account' do
    it 'sings up user' do
      data = {
        uid:  ['xuser1'],
        mail: ['xuser1@stuba.sk']
      }

      Stuba::Ais.stub(:authenticate!) { Stuba::User.new(data) }

      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'xuser1'
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content('xuser1')
      expect(page).to have_content('xuser1@stuba.sk')
    end
  end
end
