require 'spec_helper'

describe 'Add Answer', type: :feature do
  context 'with question from student' do
    let(:user)      { create :user }
    let!(:question) { create :question, :with_tags }

    before :each do
      login_as user
    end

    it 'adds new answer to question' do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď – je povinná položka')

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_content('My neat solution')
      end
    end
  end

  context 'with anonymous question' do
    let(:user)      { create :user, login: 'john' }
    let!(:question) { create :question, :anonymous, author: user }

    before :each do
      login_as user
    end

    it 'adds new answer anonymously' do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My anonymous answer'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_content('My anonymous answer')
        expect(page).to have_content('Pridal Anonym')
      end
    end

    it 'adds new answer not anonymously', js: true do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My answer'

      find('label', text: 'Pridať anonymne').click

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_content('My answer')
        expect(page).to have_content('Pridal john')
      end
    end
  end

  context 'with question from slido' do
    let!(:teacher) { create :teacher }
    let!(:student) { create :user }
    let!(:question) { create :question, author: Shared::User.find_by(login: :slido) }
    let!(:question_2) { create :question, author: Shared::User.find_by(login: :slido) }
    let!(:answered_question) { create :question, :with_answers, author: Shared::User.find_by(login: :slido) }
    let!(:answer) { create :answer, author: teacher, question: question_2 }

    it 'adds first answer to slido question by teacher' do
      login_as teacher

      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by teacher' do
      login_as teacher

      visit shared.root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds first answer to slido question by student' do
      login_as student

      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by student' do
      login_as student

      visit shared.root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'keeps best label after saving existing answer' do
      login_as teacher

      visit shared.root_path

      click_link 'Otázky'
      click_link question_2.title

      expect(page).to have_css('.answer-labeling-best a.answer-labeled-best')

      answer.save

      expect(page).to have_css('.answer-labeling-best a.answer-labeled-best')
    end
  end
end
