require 'spec_helper'

describe 'User Profile', type: :feature do
  context 'with AIS user' do
    let(:user) { build :user, :as_ais }

    before :each do
      login_as user, with: :AIS, password: 'password'
    end

    it 'disallows editing of password', js: true do
      visit shared.edit_user_registration_path

      click_link 'Účet'

      expect(page).to have_field('user_password', disabled: true)
      expect(page).to have_field('user_password_confirmation', disabled: true)

      click_button 'Uložiť'

      expect(page).to have_content('Aktuálne heslo – je povinná položka')

      fill_in 'user_current_password', with: 'password'
      save_screenshot

      click_button 'Uložiť'

      expect(page).to have_content('Úspešne ste aktualizovali Váš účet.')
      expect(page.current_path).to eql(shared.edit_user_registration_path)

      expect(Shared::User.find_by(login: user.login).encrypted_password).to be_empty
    end
  end
end
