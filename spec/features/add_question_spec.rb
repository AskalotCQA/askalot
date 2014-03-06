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

    select2 category.name, from: 'question_category_id'

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

    within '.question-content' do
      expect(page).to have_content('Lorem ipsum')
    end
  end

  it 'adds new question anonymously' do
    visit root_path

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

  context 'when using markdown' do
    it 'renders preview', js: true do
      visit root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: 'Lorem ipsum title?'
      fill_in 'question_text',  with: '# Lorem ipsum'

      click_link 'Náhľad'

      wait_for_remote

      within '.markdown-content' do
        expect(page).to have_css('h1', count: 1)
        expect(page).to have_content('Lorem ipsum')
      end
    end

    it 'embeds emoji icons' do
      visit root_path

      click_link 'Opýtať sa otázku'

      select  category.name,    from: 'question_category_id'
      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: ':poop:'

      click_button 'Opýtať'

      within '.question-content' do
        expect(page).to have_css('img.gemoji[src="/images/gemoji/poop.png"]')
      end
    end

    it 'embeds references to user' do
      create :user, login: :smolnar

      visit root_path

      click_link 'Opýtať sa otázku'

      select  category.name,    from: 'question_category_id'
      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: '@smolnar'

      click_button 'Opýtať'

      within '.question-content' do
        expect(page).to have_link('@smolnar', href: user_path(:smolnar))
      end
    end

    it 'embeds reference to user' do
      question = create :question

      visit root_path

      click_link 'Opýtať sa otázku'

      select  category.name,    from: 'question_category_id'
      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: "##{question.id}"

      click_button 'Opýtať'

      within '.question-content' do
        expect(page).to have_link("##{question.id}", href: question_path(question))
      end
    end

    context 'with link for question' do
      it 'embeds reference to question' do
        question = create :question

        visit root_path

        click_link 'Opýtať sa otázku'

        select  category.name,    from: 'question_category_id'
        fill_in 'question_title', with: 'Lorem ipsum?'
        fill_in 'question_text',  with: "https://askalot.fiit.stuba.sk#{question_path(question)}"

        click_button 'Opýtať'

        within '.question-content' do
          expect(page).to have_link("##{question.id}", href: question_path(question))
        end
      end
    end

    context 'with link for user' do
      it 'embeds reference to user' do
        create :user, login: :smolnar

        visit root_path

        click_link 'Opýtať sa otázku'

        select  category.name,    from: 'question_category_id'
        fill_in 'question_title', with: 'Lorem ipsum?'
        fill_in 'question_text',  with: "https://askalot.fiit.stuba.sk#{user_path('smolnar')}"

        click_button 'Opýtať'

        within '.question-content' do
          expect(page).to have_link("@smolnar", href: user_path('smolnar'))
        end
      end
    end

  end

  context 'when selecting category' do
    before :each do
      create :category, name: 'Westside Playground', tags: ['westside', 'ali-gz']
    end

    it 'shows automaticaly assigned tags', js: true do
      visit root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: "Ain't Westside tha best?"
      fill_in 'question_text',  with: "Y'll eastsiders: Talk to the hand, 'cos the face ain't listening."

      select2 'Westside Playground', from: 'question_category_id'

      within '#question-category-tags' do
        expect(page).to have_content('westside')
        expect(page).to have_content('ali-gz')
      end

      click_button 'Opýtať'

      expect(page).to have_content('Vaša otázka bola úspešne pridaná.')
    end

    context 'after realoading page' do
      it 'shows automaticly assigned tags', js: true do
        visit root_path

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
