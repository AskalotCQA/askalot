require 'spec_helper'

describe 'Administration', type: :feature do
  let(:administrator) { create :administrator }

  before :each do
    login_as administrator

    visit shared.administration_root_path
  end

  it 'shows administration when user is administrator' do
    within '.nav-pills' do
      expect(page).to have_content('Kategórie')
      expect(page).to have_content('Roly používateľov')
      expect(page).to have_content('Protokoly zmien')
      expect(page).to have_content('Novinky')
      expect(page).to have_content('Hromadný e-mail')
      expect(page).to have_content('Typy otázok')
    end
  end

  it 'copies categories', js: true do
    find(:css, ".treetable-checkbox[name='copied[]'][value='#{Shared::Category.find_by(depth: 2).id }']").set(true)

    select2 Shared::Context::Manager.context_category.name, from: 'copy-categories_parent_id'

    click_button 'Kopírovať kategórie'

    expect(page).to have_text('Kategórie boli úspešne upravené')
    expect(Shared::Category.count).to eql(Rails.module.mooc? ? 5 : 6)
  end

  it 'can update category settings', js: true do
    expect(all(".treetable-checkbox[name='shared[]']:checked").count).to eql(4)

    find(:css, ".treetable-checkbox[name='shared[]'][value='#{Shared::Category.find_by(depth: 2).id}']").set(false)
    find(:css, ".treetable-checkbox[name='askable[]'][value='#{Shared::Category.find_by(depth: 2).id}']").set(false)
    find(:css, ".treetable-checkbox[name='visible[]'][value='#{Shared::Category.find_by(depth: 2).id}']").set(false)

    select2 Shared::Context::Manager.context_category.name, from: 'copy-categories_parent_id'

    click_button 'Upraviť nastavenia', match: :first

    expect(page).to have_text('Kategórie boli úspešne upravené')

    expect(Shared::Category.find_by(depth: 2).shared).to eql(false)
    expect(Shared::Category.find_by(depth: 2).askable).to eql(false)
    expect(Shared::Category.find_by(depth: 2).visible).to eql(false)
    expect(all(".treetable-checkbox[name='shared[]']:checked").count).to eql(3)
  end

  it 'creates new category', js: true do
    click_link 'Pridať kategóriu'

    fill_in 'category[name]', with: 'New category'

    click_button 'Pridať kategóriu'

    expect(page).to have_text('Kategória bola úspešne pridaná.')
    expect(Shared::Category.count).to eql(Rails.module.mooc? ? 5 : 6)
  end
end
