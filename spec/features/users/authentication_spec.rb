require 'spec_helper'

describe 'User Authentication' do
  let(:user) { create :user, password: 'password' }

  context 'when registered' do
    it 'should sign in user successfully' do
      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      page.should have_content('Úspešne prihlásený.')
      page.should have_content("Prihlásený ako #{user.login}")

      click_link 'Odhlásiť'

      page.should have_content('Úspešne odhlásený.')
    end
  end

  context 'when using AIS account' do
    it 'should register user' do
      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'xmylogin1'
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      current_path.should eql(edit_user_registration_path)

      page.should have_content('')
      page.should have_content('xmylogin1')
    end
  end
end
