require 'spec_helper'

describe 'Add Comment' do
  let(:user) { create :user }
  let!(:question) { create :question, :with_tags }

  before :each do
    login_as user
  end

  it 'adds new comment' do
    visit root_path

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

    expect(page).to have_content('Váš komentár bol úspešne pridaný.')

    within '#question-comments' do
      expect(page).to have_content('My comment')
    end
  end

  context 'when using markdown' do
    it 'renders only links and mentions' do
      create :user, login: :smolnar

      visit root_path

      click_link 'Otázky'
      click_link question.title

      within '#question-comments' do
        click_link 'Pridať komentár'

        fill_in 'comment[text]', with: '# Hey, @smolnar, check out [askalot](https://askalot.fiit.stuba.sk) and http://www.example.com'

        click_button 'Komentovať'
      end

      within '#question-comments' do
        expect(page).not_to have_css('h1')
        expect(page).to     have_content('Hey, @smolnar, check out askalot and http://www.example.com')

        expect(page).to     have_link('@smolnar', href: user_path(:smolnar))
        expect(page).to     have_link('askalot',  href: 'https://askalot.fiit.stuba.sk')
        expect(page).to     have_link('askalot',  href: 'http://www.example.com')
      end
    end
  end
end
