require 'spec_helper'

describe 'Search Categories', type: :feature do
  let!(:user) { create :user }

  before :each do
    Shared::Category.autoimport = true
    Shared::Category.probe.index.reload

    login_as user

    create :category, name: 'rails'
    create :category, name: 'ruby'
    create :category, name: 'linux'
  end

  it 'searches categories by name' do
    visit shared.root_path

    click_link 'Kategórie'

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
