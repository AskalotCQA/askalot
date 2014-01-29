require 'spec_helper'

describe 'Add Question' do
  let(:user) { create :user }
  let!(:category) { create :category }

  before :each do
    login_as user
  end

  it 'adds new question', js: true do
    visit root_path

    click_link 'Opýtať sa otázku'

    fill_in 'question_title', with: ''
    fill_in 'question_text',  with: ''

    click_button 'Opýtať'

    expect(page).to have_content('Nadpis – je povinná položka')
    expect(page).to have_content('Text – je povinná položka')

    fill_in 'question_title', with: 'Lorem ipsum title?'
    fill_in 'question_text',  with: 'Lorem ipsum'

    select category.name, from: 'question_category_id'

    fill_in_select2 'question_tag_list', with: 'linux server'
    fill_in_select2 'question_tag_list', with: 'elasticsearch'

    click_button 'Opýtať'

    expect(page).to have_content('Vaša otázka bola úspešne pridaná.')

    expect(Question).to have(1).record

    within '#question-title' do
      expect(page).to have_content('Lorem ipsum title?')
      expect(page).to have_content(category.name)
      expect(page).to have_content('elasticsearch')
      expect(page).to have_content('linux-server')
    end

    within '#question-content' do
      expect(page).to have_content('Lorem ipsum')
    end
  end
end
