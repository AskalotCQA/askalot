require 'spec_helper'

describe 'Following user' do
  let!(:user)       { create :user }
  let!(:other_user) { create :user }

  before :each do
    login_as user

    unless example.metadata[:skip_before]
      user.follow! other_user
    end
  end

  context 'following from profile page', js: true do
    it 'set user is following other user', skip_before: true do
      visit root_path

      click_link 'Používatelia'
      click_link other_user.nick

      click_link 'Nasledovať'

      wait_for_remote

      expect(user).to be_following(other_user)
    end

    it 'set user is not following other user' do
      visit root_path

      click_link 'Používatelia'
      click_link other_user.nick

      click_link 'Nenasledovať'

      wait_for_remote

      expect(user).not_to be_following(other_user)
    end
  end

  context 'following from users page', js: true do
    it 'set user is following other user', skip_before: true do
      visit root_path

      click_link 'Používatelia'

      click_link "user-#{other_user.id}-follow"

      wait_for_remote

      expect(user).to be_following(other_user)
    end

    it 'set user is not following other user' do
      visit root_path

      click_link 'Používatelia'

      click_link "user-#{other_user.id}-follow"

      wait_for_remote

      expect(user).not_to be_following(other_user)
    end
  end

  context 'check followees and followers list', js: true do
    it 'shows followers list' do
      visit root_path

      click_link 'Používatelia'
      click_link other_user.nick

      click_link 'Nasledovateľ'

      expect(page).to have_content(user.nick)
    end

    it 'set user is not following other user' do
      visit root_path

      click_link user.nick

      click_link "Nasledovaný"

      expect(page).to have_content(other_user.nick)
    end
  end
end
