require 'spec_helper'

describe 'User Authentication' do
  let(:user) { create :user, password: 'password' }

  context 'when not registered' do
    it 'does not sign in user successfully' do
      Stuba::AIS.stub(:authenticate) { nil }

      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'bogus'
      fill_in 'user_password', with: 'bogus'

      click_button 'Prihlásiť'

      expect(page).to have_content('Nesprávne prihlasovacie údaje.')
    end
  end

  context 'when registered' do
    it 'signs in user successfully' do
      Stuba::AIS.stub(:authenticate) { nil }

      visit root_path

      click_link 'Prihlásiť'

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content("Prihlásený ako #{user.login}")

      click_link 'Odhlásiť'

      expect(page).to have_content('Úspešne odhlásený.')
    end
  end

  context 'when using AIS account' do
    it 'sings up user' do
      data = {
        uisid: ['1234'],
        uid: ['xuser1'],
        cn: ['Bc. Janko Hrasko'],
        sn: ['Hrasko'],
        givenname: ['Janko'],
        mail: ['xuser1@is.stuba.sk','xuser1@stuba.sk']
      }

      Stuba::AIS.stub(:authenticate) { Stuba::User.new(data) }

      visit root_url

      click_link 'Prihlásiť'

      fill_in 'user_login', with: 'xuser1'
      fill_in 'user_password', with: 'password'

      click_button 'Prihlásiť'

      expect(page).to have_content('Úspešne prihlásený.')
      expect(page).to have_content('xuser1')
      expect(page).to have_content('xuser1@stuba.sk')

      expect(User).to have(1).record

      user = User.first

      expect(user.login).to eql('xuser1')
      expect(user.ais_login).to eql('xuser1')
      expect(user.ais_uid).to eql('1234')
      expect(user.nick).to eql('xuser1')
      expect(user.encrypted_password).to be_empty
    end
  end
end
