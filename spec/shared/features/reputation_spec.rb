require 'spec_helper'

describe 'Reputation', type: :feature do
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }
  let(:user4) { create :user }

  before :each do
    login_as user
  end

  it 'shows reputation icons on users page', js: true do
    user.profiles.of('reputation').first.update(value: -1)
    user2.profiles.of('reputation').first.update(value: 1)
    user3.profiles.of('reputation').first.update(value: 2)
    user4.profiles.of('reputation').first.update(value: 3)

    visit shared.users_path

    expect(all('.user-reputation-gold').count).to eql(1)
    expect(all('.user-reputation-silver').count).to eql(1)
    expect(all('.user-reputation-bronze').count).to eql(1)
    expect(all('.user-reputation-negative').count).to eql(1)
  end
end
