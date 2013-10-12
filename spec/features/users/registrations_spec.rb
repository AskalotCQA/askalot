require 'spec_helper'

describe 'User Registrations' do
  context 'when using login' do
    it 'should register user' do
      visit root_path

      click_link 'Sign Up'

      fill_in 'user_login', with: 'example'
      fill_in 'user_email', with: 'example@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'

      click_button 'Sign up'

      page.should have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
    end
  end
end
