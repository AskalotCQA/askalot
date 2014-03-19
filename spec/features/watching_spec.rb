require 'spec_helper'

describe 'Watching' do
  let(:user)      { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  context 'with question' do
    it 'registers author as watcher as question' do
      visit root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: 'Watched question'
      fill_in 'question_text',  with: 'Lorem ipsum'

      select category.name, from: 'question_category_id'

      click_button 'Opýtať'

      question = Question.find_by(title: 'Watched question')

      expect(question).to be_watched_by(user)
    end

    it 'registers watching for question', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link "question-#{question.id}-watch"

      wait_for_remote

      expect(question).to be_watched_by(user)
    end
  end

  context 'with answer' do
    it 'registers answer author as watcher of question' do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My answer'

      click_button 'Odpovedať'

      expect(question).to be_watched_by(user)
    end
  end

  context 'with comment' do
    it 'registers commenter as watcher of question' do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      within '#question-comments' do
        click_link 'Pridať komentár'

        fill_in 'comment[text]', with: 'My comment'

        click_button 'Komentovať'
      end

      expect(question).to be_watched_by(user)
    end
  end

  context 'with tag' do
    it 'registers watching for tag' do
      pending
    end
  end

  context 'with category' do
    let!(:category) { create :category }

    it 'registers watching for category', js: true do
      visit root_path

      click_link 'Kategórie'

      click_link "category-#{category.id}-watch"

      wait_for_remote

      expect(category).to be_watched_by(user)
    end
  end
end
