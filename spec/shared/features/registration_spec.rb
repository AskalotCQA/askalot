require 'spec_helper'

describe 'Registration', type: :feature, js: true do
  context 'with provided login' do
    it 'signs up user' do
      visit shared.root_path

      click_link 'Registrovať'

      fill_in 'user_login', with: 'example'
      fill_in 'user_email', with: 'example@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'

      click_button 'Registrovať'

      expect(page).to have_content('Pre ďalšie pokračovanie v práci so systémom je potrebné registráciu potvrdiť.')
      expect(page).to have_content('Správa s potvrdzovacím odkazom bola odoslaná na Vašu e-mailovú adresu. Prosím otvorte odkaz, aby ste potvrdili registráciu.')

      expect(last_email.to).to eql(['example@gmail.com'])
    end
  end
end
