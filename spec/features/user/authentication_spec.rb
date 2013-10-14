require 'spec_helper'

describe 'User Authentication' do
  let(:user) { create :user, password: 'password' }

  context 'when registered' do
    it 'signs in user successfully' do
      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content("Prihlásený ako #{user.login}")

      click_link 'Odhlásiť'

      expect(page).to  have_content('Úspešne odhlásený.')
    end
  end

  context 'when using AIS account' do
    it 'sings up user' do
      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'xmylogin1'
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(current_path).to eql(edit_user_registration_path)

      expect(page).to have_content('')
      expect(page).to have_content('xmylogin1')
    end
  end
end
