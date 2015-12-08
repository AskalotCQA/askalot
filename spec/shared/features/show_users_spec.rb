require 'spec_helper'

describe 'Show Users', js: true do
  let(:user) { create :user }

  let!(:active_users) { 4.times.map { |u| create :user }}
  let!(:alumni_users) { 4.times.map { |u| create :user, :alumni }}

  before :each do
    login_as user
  end

  it 'shows list of all users' do
    visit root_path

    click_link 'Používatelia'

    within '#users-tabs' do
      click_link 'Všetci'

      wait_for_remote
    end

    list = all('#users .user-square')

    expect(list.size).to eq(10)
  end

  it 'shows list of alumni users' do
    visit root_path

    click_link 'Používatelia'

    within '#users-tabs' do
      click_link 'Alumni'

      wait_for_remote
    end

    list = all('#users .user-square')

    expect(list.size).to eq(4)

    expect(page).to have_content(Shared::User.last.nick)
  end

  it 'shows list of recent users' do
    skip
  end
end
