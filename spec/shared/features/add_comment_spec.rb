require 'spec_helper'

describe 'Add Comment', type: :feature do
  let(:user) { create :user }
  let!(:question) { create :question, :with_tags }

  before :each do
    login_as user
  end

  it 'adds new comment' do
    visit shared.root_path

    click_link 'Otázky'
    click_link question.title

    within '#question-comments' do
      click_link 'Pridať komentár'

      click_button 'Komentovať'
    end

    expect(page).to have_content('Komentár – je povinná položka')

    within '#question-comments' do
      click_link 'Pridať komentár'

      fill_in 'comment[text]', with: 'My comment'

      click_button 'Komentovať'
    end

    expect(page).to have_content('Komentár bol úspešne pridaný.')

    within '#question-comments' do
      expect(page).to have_content('My comment')
    end
  end

  context 'for question' do
    context 'with notifications' do
      it 'registers commenter as watcher of question' do
        visit shared.root_path

        click_link 'Otázky'
        click_link question.title

        within '#question-comments' do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(question).to be_watched_by(user)
      end
    end
  end

  context 'with anonymous question' do
    let(:user)      { create :user, login: 'john' }
    let!(:question) { create :question, :anonymous, author: user }

    it 'adds new comment anonymously' do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      within '#question-comments' do
        click_link 'Pridať komentár'

        fill_in 'comment[text]', with: 'I think this is wrong!'

        click_button 'Komentovať'
      end

      expect(page).to have_content('Komentár bol úspešne pridaný.')

      within '#question-comments' do
        expect(page).to have_content('I think this is wrong')
        expect(page).to have_content('Anonym')
      end
    end

    it 'adds new comment not anonymously', js: true do
      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      within '#question-comments' do
        click_link 'Pridať komentár'

        find('label', text: 'Pridať anonymne').click

        fill_in 'comment[text]', with: 'I think this is wrong!'

        click_button 'Komentovať'
      end

      expect(page).to have_content('Komentár bol úspešne pridaný.')

      within '#question-comments' do
        expect(page).to have_content('I think this is wrong!')
        expect(page).to have_content('john')
      end
    end
  end
end
