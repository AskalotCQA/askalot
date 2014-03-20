require 'spec_helper'

describe 'Markdown' do
  let(:user) { create :user }
  let!(:question) { create :question, :with_tags }
  let!(:category) { create :category }

  before :each do
    login_as user
  end

  context 'with question' do
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
      other = create :user, login: :smolnar

      visit root_path

      click_link 'Opýtať sa otázku'

      select  category.name,    from: 'question_category_id'
      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: '@smolnar'

      click_button 'Opýtať'

      within '.question-content' do
        expect(page).to have_link('@smolnar', href: user_path(:smolnar))
      end

      expect(notifications.size).to eql(1)

      question = Question.last

      expect(last_notification.notifiable).to eql(question)
      expect(last_notification.recipient).to  eql(other)
      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.action).to     eql(:mention)
    end

    it 'embeds reference to question' do
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
        user = create :user, login: :smolnar

        visit root_path

        click_link 'Opýtať sa otázku'

        select  category.name,    from: 'question_category_id'
        fill_in 'question_title', with: 'Lorem ipsum?'
        fill_in 'question_text',  with: "https://askalot.fiit.stuba.sk#{user_path(user.nick)}"

        click_button 'Opýtať'

        within '.question-content' do
          expect(page).to have_link("@#{user.nick}", href: user_path(user.nick))
        end
      end
    end

    context 'when showing question' do
      before :each do
        question.update_attributes!(text: '# Lorem ipsum')
      end

      it 'processes markdown text' do
        visit root_path

        click_link 'Otázky'

        click_link question.title

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.author.nick)

        within '.question-content' do
          expect(page).to have_css('h1', count: 1)
          expect(page).to have_content('Lorem ipsum')
        end

        question.tags.pluck(:name).each { |tag| expect(page).to have_content(tag) }
      end
    end
  end

  context 'with answer' do
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

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_css('h1', count: 1)
        expect(page).to have_content('My neat solution')
      end
    end

    it 'embers reference to user and question' do
      other = create :user, login: :smolnar

      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: "Hey, @smolnar, look at this ##{question.id}!"

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')

      within '#question-answers' do
        expect(page).to have_link('@smolnar',        href: user_path(:smolnar))
        expect(page).to have_link("##{question.id}", href: question_path(question))
      end

      expect(notifications.size).to eql(1)

      answer = Answer.last

      expect(last_notification.notifiable).to eql(answer)
      expect(last_notification.recipient).to  eql(other)
      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.action).to     eql(:mention)
    end
  end

  context 'for comment' do
    it 'renders only links and mentions' do
      other = create :user, login: :smolnar

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
        expect(page).to     have_link('http://www.example.com',  href: 'http://www.example.com')
      end

      expect(notifications.size).to eql(1)

      comment = Comment.last

      expect(last_notification.notifiable).to eql(comment)
      expect(last_notification.recipient).to  eql(other)
      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.action).to     eql(:mention)
    end
  end
end
