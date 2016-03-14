require 'spec_helper'

describe 'Search Categories', type: :feature do
  let!(:user) { create :user }

  before :each do
    Shared::Category.autoimport = true
    Shared::Category.probe.index.reload

    login_as user

    create :category, name: 'rails', description: 'rails-description'
    create :category, name: 'ruby', description: 'ruby-description'
    create :category, name: 'linux', description: 'linux-description'
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

    expect(page).to     have_content('rails-description')
    expect(page).to     have_content('ruby-description')
    expect(page).to     have_content('linux-description')

    fill_in 'q', with: 'r'
    click_button 'search-submit'

    expect(page).to     have_content('rails-description')
    expect(page).to     have_content('ruby-description')
    expect(page).not_to have_content('linux-description')

    fill_in 'q', with: 'ux'
    click_button 'search-submit'

    expect(page).to     have_content('linux-description')
  end

  it 'displays categories description in category view' do
    visit shared.root_path

    click_link 'Kategórie'

    expect(page).to     have_content('rails-description')

    click_link 'rails'

    expect(page).to     have_content('rails-description')
  end
end
