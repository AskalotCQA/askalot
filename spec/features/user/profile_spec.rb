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
    end

    it 'edits basic profile', js: true do
      visit root_path

      click_link user.email
      click_link 'Nastavenia'

      fill_in 'user_nick',  with: 'Nicky'
      fill_in 'user_first', with: 'Nick'
      fill_in 'user_last',  with: 'Nickmann'
      fill_in 'user_about', with: 'Lorem Ipsum'

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(edit_user_registration_path)

      user.reload

      expect(user.nick).to  eql('Nicky')
      expect(user.first).to eql('Nick')
      expect(user.last).to  eql('Nickmann')
      expect(user.about).to eql('Lorem Ipsum')
    end
  end
end
