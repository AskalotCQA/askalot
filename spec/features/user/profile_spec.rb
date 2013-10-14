require 'spec_helper'

describe 'User Profile' do
  let(:user) { create :user }

  context 'when showing current user' do
    before :each do
      login_as user
    end

    it 'shows user profile' do
      visit root_path

      click_link 'Profil'

      expect(page).to have_content(user.login)
    end

    it 'allows editing of user profile' do
      visit root_path

      click_link 'Profil'

      expect(page).to have_content(user.login)

      click_link 'Upraviť profil'
    end
  end
end
