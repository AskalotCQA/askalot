require 'spec_helper'

describe 'User Profile' do
  let(:user) { create :user }

  context 'with registered user' do
    before :each do
      login_as user
    end

    it 'shows user profile' do
      visit root_path

      click_link user.nick

      expect(page).to have_content(user.nick)
      expect(page).to have_content(user.email)
      expect(page).to have_content("#{user.first} #{user.last}")
      expect(page).to have_content(user.about)
    end

    it 'edits user account', js: true do
      visit edit_user_registration_path

      click_link 'Účet'

      fill_in 'user_email', with: 'nicky.nickmangmail.com'

      click_button 'Uložiť'

      expect(page).to have_content('E-mail – nie je platná hodnota.')

      click_link 'Účet'

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'

      click_button 'Uložiť'

      expect(page).to have_content('Aktuálne heslo – je povinná položka')

      click_link 'Účet'

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'
      fill_in 'user_password', with: 'new password'
      fill_in 'user_password_confirmation', with: 'new password'
      fill_in 'user_current_password', with: user.password

      click_button 'Uložiť'

      expect(page.current_path).to eql(edit_user_registration_path)
      expect(page).to have_content('Váš účet bol úspešne aktualizovaný ale potrebujeme overiť Vašu novú e-mailovú adresu.')
    end

    it 'edits basic user profile', js: true do
      visit edit_user_registration_path

      click_link 'Profil'

      fill_in 'user_nick', with: ''

      click_button 'Uložiť'

      expect(page).to have_content('Prezývka – je povinná položka.')
      expect(page.current_path).to eql(edit_user_registration_path)

      fill_in 'user_nick', with: '*()BadNick*-'
      fill_in 'user_first', with: '65badFirst?#$%'
      fill_in 'user_last', with: '(01BadLast)'
      fill_in 'user_gravatar_email', with: 'gravatar.email'

      click_button 'Uložiť'

      expect(page).to have_content('Prezývka – nie je platná hodnota.')
      expect(page).to have_content('Gravatar e-mail – nie je platná hodnota.')
      expect(page).to have_content('Krstné meno – nie je platná hodnota.')
      expect(page).to have_content('Priezvisko – nie je platná hodnota.')
      expect(page.current_path).to eql(edit_user_registration_path)

      click_link 'Profil'

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
      visit edit_user_registration_path

      click_link 'Sociálne siete'

      fill_in 'user_facebook', with: 'http://facebook.com/'
      fill_in 'user_twitter',  with: 'http://twitter.com/'
      fill_in 'user_linkedin', with: 'http://linkedin.com/in/'

      click_button 'Uložiť'

      expect(page).to have_content('Facebook – nie je platná hodnota.')
      expect(page).to have_content('Twitter – nie je platná hodnota.')
      expect(page).to have_content('Linkedin – nie je platná hodnota.')
      expect(page.current_path).to eql(edit_user_registration_path)

      click_link 'Sociálne siete'

      fill_in 'user_facebook', with: 'http://facebook.com/nicky.nickmann'
      fill_in 'user_twitter',  with: 'http://twitter.com/nnickmann'
      fill_in 'user_linkedin', with: 'http://linkedin.com/in/nick.nickmann.jr'

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      click_link 'Sociálne siete'

      expect(page).to have_field('user_facebook', with: 'http://facebook.com/nicky.nickmann')
      expect(page).to have_field('user_twitter',  with: 'http://twitter.com/nnickmann')
      expect(page).to have_field('user_linkedin', with: 'http://linkedin.com/in/nick.nickmann.jr')
    end
  end

  context 'with AIS user' do
    let(:user) { build :user, :as_ais }

    before :each do
      ais_login_as user
    end

    it 'disallows editing of first and last name', js: true do
      visit edit_user_registration_path

      click_link 'Profil'

      fill_in 'user_nick', with: 'Nicky'
      fill_in 'user_about', with: 'Lorem ipsum'

      expect(page).not_to have_field('user_first')
      expect(page).not_to have_field('user_last')

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      expect(page).to have_field('user_nick',  with: 'Nicky')
      expect(page).to have_field('user_about', with: 'Lorem ipsum')
    end

    it 'edits user privacy', js: true do
      pending
    end
  end
end
