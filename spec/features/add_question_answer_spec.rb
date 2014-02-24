require 'spec_helper'

describe 'Add Question Answer' do
  context 'with question from student' do
    let!(:question) { create :question, :with_tags }

    before :each do
      login_as question.author
    end

    it 'adds new answer to question' do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď – je povinná položka')

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_content('My neat solution')
      end
    end

    context 'when using markdown' do
      it 'renders preview of the answer', js: true do
        visit root_path

        click_link 'Otázky'
        click_link question.title

        fill_in 'answer_text', with: '# My neat solution'

        click_link 'Náhľad'

        wait_for_remote

        within '.markdown-content' do
          expect(page).to have_css('h1', count: 1)
          expect(page).to have_content('My neat solution')
        end
      end

      it 'processes answer text' do
        visit root_path

        click_link 'Otázky'
        click_link question.title

        fill_in 'answer_text', with: '# My neat solution'

        click_button 'Odpovedať'

        expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')

        within '#question-answers' do
          expect(page).to have_css('h1', count: 1)
          expect(page).to have_content('My neat solution')
        end
      end
    end
  end

  context 'with question from slido' do
    let!(:question) { create :question, author: User.find_by(login: :slido) }
    let!(:answered_question) { create :question, :with_answers, author: (User.find_by login: :slido) }
    let!(:teacher) { create :teacher }
    let!(:student) { create :user }

    it 'adds first answer to slido question by teacher' do
      login_as teacher

      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')
      expect(page).to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by teacher' do
      login_as teacher

      visit root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds first answer to slido question by student' do
      login_as student

      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by student' do
      login_as student

      visit root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end
  end
end
