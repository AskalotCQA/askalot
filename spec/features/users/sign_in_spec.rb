require 'spec_helper'

describe 'User Sign In' do
  let(:user) { create :user, password: 'password' }

  context 'when registered' do
    it 'should sign in user successfully' do
      visit root_url

      click_link 'Sign In'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Sign in'

      page.should have_content('Signed in successfully.')
      page.should have_content("Signed in as #{user.login}")

      click_link 'Sign Out'

      page.should have_content('Signed out successfully.')
    end
  end

  context 'when using AIS account' do
    it 'should register user' do
      pending
    end
  end
end
