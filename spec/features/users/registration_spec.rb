require 'spec_helper'

describe 'User Registration' do
  context 'when using login' do
    it 'should register user' do
      visit root_path

      click_link 'Registrovať'

      fill_in 'user_login', with: 'example'
      fill_in 'user_email', with: 'example@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'

      click_button 'Registrovať'

      page.should have_content('Správa s potvrdzovacím odkazom bola odoslaná na Vašu e-mailovú adresu.')

      last_email.to.should eql(['example@gmail.com'])
    end
  end
end
