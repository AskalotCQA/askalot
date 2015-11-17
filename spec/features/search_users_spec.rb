require 'spec_helper'

describe 'Search Users' do
  let!(:user) { create :user, login: 'smolnar' }

  before :each do
    Shared::User.autoimport = true
    Shared::User.probe.index.reload

    login_as user

    create :user, login: 'kyle'
    create :user, login: 'kenny'
  end

  it 'searches users by name' do
    visit root_path

    click_link 'Používatelia', match: :first

    fill_in 'q', with: 'k'
    click_button 'search-submit'

    within '#users' do
      expect(page).to     have_content('kyle')
      expect(page).to     have_content('kenny')
      expect(page).not_to have_content('smolnar')
    end

    fill_in 'q', with: 'sm'
    click_button 'search-submit'

    within '#users' do
      expect(page).to have_content('smolnar')
    end
  end

  it 'paginates through records' do
    users = 60.times.map { |n| create :user, name: "user_#{n}" }

    visit root_path

    click_link 'Používatelia', match: :first

    fill_in 'q', with: 'user_'
    click_button 'search-submit'

    within '#users' do
      users.first(30).each do |user|
        expect(page).to have_content(user.login)
      end
    end

    within '.pagination' do
      click_link '2'
    end

    within '#users' do
      users[30...60].each do |user|
        expect(page).to have_content(user.login)
      end
    end
  end
end
