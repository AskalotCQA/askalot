require 'spec_helper'

describe 'Search Categories', type: :feature do
  let!(:user) { create :user }

  before :each do
    Shared::Category.autoimport = true
    Shared::Category.probe.index.reload

    login_as user

    create :category, name: 'rails', description: 'rails-desc'
    create :category, name: 'ruby', description: 'ruby-desc'
    create :category, name: 'linux', description: 'linux-desc'
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

  it 'displays categories description' do
    visit shared.root_path

    click_link 'Kategórie'

    expect(page).to     have_content('rails-desc')
    expect(page).to     have_content('ruby-desc')
    expect(page).to     have_content('linux-desc')

    fill_in 'q', with: 'r'
    click_button 'search-submit'

    expect(page).to     have_content('rails-desc')
    expect(page).to     have_content('ruby-desc')
    expect(page).not_to have_content('linux-desc')

    fill_in 'q', with: 'ux'
    click_button 'search-submit'

    expect(page).to     have_content('linux-desc')
  end

  it 'displays categories description in category view' do
    visit shared.root_path

    click_link 'Kategórie'

    expect(page).to     have_content('rails-desc')

    click_link 'rails', match: :first

    expect(page).to     have_content('rails-desc')
  end
end
