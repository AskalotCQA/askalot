require 'spec_helper'

describe 'User Profile' do
  let(:user) { create :user }

  context 'when showing current user' do
    before :each do
      login_as user
    end

    it 'should show user profile' do
      visit root_path

      click_link 'Profil'

      page.should have_content(user.login)
    end

    it 'should allow edit' do
      visit root_path

      click_link 'Profil'

      page.should have_content(user.login)

      click_link 'Upraviť profil'
    end
  end
end
