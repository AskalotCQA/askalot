require 'spec_helper'

describe 'Search Categories' do
  let!(:user) { create :user }

  before :each do
    Category.probe.index.delete
    Category.probe.index.create

    login_as user

    create :category, name: 'rails'
    create :category, name: 'ruby'
    create :category, name: 'linux'
  end

  it 'searches categories by name' do
    visit root_path

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
