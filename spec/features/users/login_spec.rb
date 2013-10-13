require 'spec_helper'

describe 'User Login' do
  let(:user) { create :user, password: 'password' }

  context 'when registered' do
    it 'should login user successfully' do
      visit root_url

      click_link 'Sign In'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Sign in'

      page.should have_content('Signed in successfully.')
    end
  end
end
