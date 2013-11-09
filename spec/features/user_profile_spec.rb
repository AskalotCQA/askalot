require 'spec_helper'

describe 'User Profile' do
  let(:user) { create :user }

  context 'with current user' do
    before :each do
      login_as user
    end

    it 'shows user profile' do
      visit root_path

      click_link 'Profil'

      expect(page).to have_content(user.login)
      expect(page).to have_content(user.email)
      expect(page).to have_content("#{user.first} #{user.last}")
      expect(page).to have_content(user.about)
    end

    it 'edits user account', js: true do
      visit root_path

      click_link user.email
      click_link 'Nastavenia'

      click_link 'Nastavenia účtu'

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'

      click_button 'Uložiť'

      expect(page).to have_content('Aktuálne heslo – je povinná položka')

      click_link 'Nastavenia účtu'

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'
      fill_in 'user_password', with: 'new password'
      fill_in 'user_password_confirmation', with: 'new password'
      fill_in 'user_current_password', with: user.password

      click_button 'Uložiť'

      expect(page.current_path).to eql(edit_user_registration_path)
      expect(page).to have_content('Váš účet bol úspešne aktualizovaný ale potrebujeme overiť Vašu novú e-mailovú adresu.')
    end

    it 'edits basic user profile', js: true do
      visit root_path

      click_link user.email
      click_link 'Nastavenia'

      # TODO (smolnar) Add invalid values for models validations and check if the page shows 
      # errors

      fill_in 'user_nick',  with: 'Nicky'
      fill_in 'user_first', with: 'Nick'
      fill_in 'user_last',  with: 'Nickmann'
      fill_in 'user_about', with: 'Lorem Ipsum'

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      expect(page).to have_field('user_nick',  with: 'Nicky')
      expect(page).to have_field('user_first', with: 'Nick')
      expect(page).to have_field('user_last',  with: 'Nickmann')
      expect(page).to have_field('user_about', with: 'Lorem Ipsum')
    end

    it 'edits user social links', js: true do
      visit root_path

      click_link user.email
      click_link 'Nastavenia'

      click_link 'Sociálne siete'

      # TODO (smolnar) Add invalid values for models validations and check if the page shows
      # errors

      fill_in 'user_facebook', with: 'facebook.com/nicky.nickmann'
      fill_in 'user_twitter',  with: 'twitter.com/nnickmann'
      fill_in 'user_linkedin', with: 'linkedin.com/nick.nickmann.jr'

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      click_link 'Sociálne siete'

      expect(page).to have_field('user_facebook', with: 'facebook.com/nicky.nickmann')
      expect(page).to have_field('user_twitter',  with: 'twitter.com/nnickmann')
      expect(page).to have_field('user_linkedin', with: 'linkedin.com/nick.nickmann.jr')
    end

    it 'edits user privacy', js: true do
      pending
    end
  end
end
