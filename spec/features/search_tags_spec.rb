require 'spec_helper'

describe 'Search Tags' do
  let!(:user) { create :user }

  before :each do
    Tag.probe.index.delete
    Tag.probe.index.create

    login_as user

    create :tag, name: 'rails'
    create :tag, name: 'ruby'
    create :tag, name: 'linux'
  end

  it 'searches tags by name' do
    visit root_path

    click_link 'Tagy'

    fill_in 'q', with: 'r'
    click_button 'search-submit'

    expect(page).to     have_content('rails')
    expect(page).to     have_content('ruby')
    expect(page).not_to have_content('linux')

    fill_in 'q', with: 'ux'
    click_button 'search-submit'

    expect(page).to have_content('linux')
  end
end
