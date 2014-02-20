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
      fill_in 'user_current_password', with: user.password

      click_button 'Uložiť'

      expect(page).to have_content('E-mail – nie je platná hodnota.')

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'

      click_button 'Uložiť'

      expect(page).to have_content('Aktuálne heslo – je povinná položka')

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'
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

      fill_in 'user_facebook',       with: 'http://facebook.com/'
      fill_in 'user_twitter',        with: 'http://twitter.com/'
      fill_in 'user_linkedin',       with: 'http://linkedin.com/in/'
      fill_in 'user_google_plus',    with: 'http://plus.google.com/xxx'
      fill_in 'user_bitbucket',      with: 'http://bitbucket.org/'
      fill_in 'user_github',         with: 'http://github.com/'
      fill_in 'user_youtube',        with: 'http://youtube.com/'
      fill_in 'user_stack_overflow', with: 'http://stackoverflow.com/users/xxx'

      click_button 'Uložiť'

      expect(page).to have_content('Facebook – nie je platná hodnota.')
      expect(page).to have_content('Twitter – nie je platná hodnota.')
      expect(page).to have_content('LinkedIn – nie je platná hodnota.')
      expect(page).to have_content('Google Plus – nie je platná hodnota.')
      expect(page).to have_content('Bitbucket – nie je platná hodnota.')
      expect(page).to have_content('GitHub – nie je platná hodnota.')
      expect(page).to have_content('YouTube – nie je platná hodnota.')
      expect(page).to have_content('Stack Overflow – nie je platná hodnota.')
      expect(page.current_path).to eql(edit_user_registration_path)

      fill_in 'user_facebook',       with: 'http://facebook.com/nicky.nickmann'
      fill_in 'user_twitter',        with: 'http://twitter.com/nnickmann'
      fill_in 'user_linkedin',       with: 'http://linkedin.com/in/nick.nickmann.jr'
      fill_in 'user_google_plus',    with: 'http://plus.google.com/1234567890'
      fill_in 'user_bitbucket',      with: 'http://bitbucket.org/nickynickmann'
      fill_in 'user_github',         with: 'http://github.com/nickynickmann'
      fill_in 'user_youtube',        with: 'http://youtube.com/nickynickmann'
      fill_in 'user_stack_overflow', with: 'http://stackoverflow.com/users/1234567890'

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      expect(page).to have_field('user_facebook',       with: 'http://facebook.com/nicky.nickmann')
      expect(page).to have_field('user_twitter',        with: 'http://twitter.com/nnickmann')
      expect(page).to have_field('user_linkedin',       with: 'http://linkedin.com/in/nick.nickmann.jr')
      expect(page).to have_field('user_google_plus',    with: 'http://plus.google.com/1234567890')
      expect(page).to have_field('user_bitbucket',      with: 'http://bitbucket.org/nickynickmann')
      expect(page).to have_field('user_github',         with: 'http://github.com/nickynickmann')
      expect(page).to have_field('user_youtube',        with: 'http://youtube.com/nickynickmann')
      expect(page).to have_field('user_stack_overflow', with: 'http://stackoverflow.com/users/1234567890')
    end

    it 'edits user privacy', js: true do
      pending
    end
  end

  context 'with AIS user' do
    let(:user) { build :user, :as_ais }

    before :each do
      login_as user, with: :AIS
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

    it 'disallows editing of password', js: true do
      visit edit_user_registration_path

      click_link 'Profil'

      expect(page).not_to have_field('user_password')
      expect(page).not_to have_field('user_password_confirmation')

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      expect(User.find_by(login: user.login).encrypted_password).to be_empty
    end

    it 'requires current password for changing account information', js: true do
      visit edit_user_registration_path

      click_link 'Účet'

      fill_in 'user_email', with: 'nicky.nickmann@gmail.com'

      click_button 'Uložiť'

      expect(page).to have_content('Aktuálne heslo – je povinná položka')

      fill_in 'user_current_password', with: user.password

      click_button 'Uložiť'

      expect(page).to have_content('Váš účet bol úspešne aktualizovaný ale potrebujeme overiť Vašu novú e-mailovú adresu.')
    end
  end
end
