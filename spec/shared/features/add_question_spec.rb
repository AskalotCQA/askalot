require 'spec_helper'

describe 'Add Question', type: :feature do
  let(:user) { create :user }
  let!(:category) { create :category }


  before :each do
    login_as user
  end

  it 'adds new question', js: true do
    visit shared.root_path

    click_link 'Opýtať sa otázku'

    fill_in 'question_title', with: ''
    fill_in 'question_text',  with: ''

    click_button 'Opýtať'

    expect(page).to have_content('Nadpis – je povinná položka')
    expect(page).to have_content('Text – je povinná položka')

    fill_in 'question_title', with: 'Lorem ipsum title?'
    fill_in 'question_text',  with: 'Lorem ipsum'

    select2 category.name, from: 'question_category_id'

    fill_in_select2 'question_tag_list', with: 'linux server'
    fill_in_select2 'question_tag_list', with: 'elasticsearch'

    click_button 'Opýtať'

    expect(page).to have_content('Otázka bola úspešne pridaná.')

    expect(Shared::Question.count).to eq(1)

    within '#question-title' do
      expect(page).to have_content('Lorem ipsum title?')
      expect(page).to have_content(category.name)
      expect(page).to have_content('elasticsearch')
      expect(page).to have_content('linux-server')
    end

    within '.question-content' do
      expect(page).to have_content('Lorem ipsum')
    end
  end

  it 'adds new question anonymously' do
    visit shared.root_path

    click_link 'Opýtať sa otázku'

    fill_in 'question_title', with: 'Lorem ipsum title?'
    fill_in 'question_text',  with: 'Lorem ipsum'

    select category.name, from: 'question_category_id'

    check 'Opýtať sa anonymne'

    click_button 'Opýtať'

    within '#question' do
      expect(page).to have_content('Anonym')
    end
  end

  it 'adds new question as slido' do
    if Rails.module.university?
      page.driver.submit :delete, '/logout', {}
      admin = create :administrator
      login_as admin

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: 'Lorem ipsum title?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      select category.name, from: 'question_category_id'

      check 'Pridať ako slido'

      click_button 'Opýtať'

      within '#question' do
        expect(page).to have_content('Automaton Slido')
      end
    else
      skip
    end
  end

  context 'when creating new question from a question\'s page' do
    let!(:question) { create :question, :with_tags }

    it 'selects the same category' do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      click_link 'sa opýtaj otázku v rovnakej kategórii.'

      expect(page).to have_content('Nová otázka')
      expect(page).to have_field('question_category_id', with: question.category_id)
    end
  end

  context 'when creating new question from questions index page' do
    it 'does not select category if it is not leaf category' do
      visit shared.questions_path(category: 1)

      click_link 'Pridať otázku', match: :first

      expect(page).to have_content('Nová otázka')
      expect(page).not_to have_field('question_category_id', with: 1)
      expect(page).to have_field('question_category_id', with: '')
    end
  end

  context 'when selecting category' do
    before :each do
      create :category, name: 'Westside Playground', description: 'Category description', tags: ['westside', 'ali-gz']
    end

    it 'shows automaticaly assigned tags', js: true do
      visit shared.root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: "Ain't Westside tha best?"
      fill_in 'question_text',  with: "Y'll eastsiders: Talk to the hand, 'cos the face ain't listening."

      select2 'Westside Playground', from: 'question_category_id'

      within '#question-category-tags' do
        expect(page).to have_content('westside')
        expect(page).to have_content('ali-gz')
      end

      click_button 'Opýtať'

      expect(page).to have_content('Otázka bola úspešne pridaná.')
    end

    it 'shows automaticaly description', js: true do
      visit shared.root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: "Ain't Westside tha best?"
      fill_in 'question_text',  with: "Y'll eastsiders: Talk to the hand, 'cos the face ain't listening."

      select2 'Westside Playground', from: 'question_category_id'

      within '.category-description' do
        expect(page).to have_content('Category description')
      end

      click_button 'Opýtať'

      expect(page).to have_content('Otázka bola úspešne pridaná.')
    end

    context 'after realoading page' do
      it 'shows automaticly assigned tags', js: true do
        visit shared.root_path

        click_link 'Opýtať sa otázku'

        fill_in 'question_title', with: ""

        select2 'Westside Playground', from: 'question_category_id'

        click_button 'Opýtať'

        within '#question-category-tags' do
          expect(page).to have_content('westside')
          expect(page).to have_content('ali-gz')
        end
      end
    end
  end
end
