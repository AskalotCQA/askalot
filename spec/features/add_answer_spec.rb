require 'spec_helper'

describe 'Add Answer' do
  context 'with question from student' do
    let(:user)      { create :user }
    let!(:question) { create :question, :with_tags }

    before :each do
      login_as user
    end

    it 'adds new answer to question' do
      visit root_path

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

    context 'with notifications' do
      it 'registers answer author as watcher of her answer' do
        visit root_path

        click_link 'Otázky'
        click_link question.title

        fill_in 'answer_text', with: 'I soo wanna watch you!'

        click_button 'Odpovedať'

        answer = Answer.last

        expect(answer).to be_watched_by(user)
      end

      it 'notifies watchers about new answer' do
        create :watching, watchable: question, watcher: question.author

        visit root_path

        click_link 'Otázky'
        click_link question.title

        fill_in 'answer_text', with: 'Hey, look at this.'

        click_button 'Odpovedať'

        expect(notifications.size).to eql(1)

        answer = Answer.last

        expect(last_notification.initiator).to  eql(user)
        expect(last_notification.recipient).to  eql(question.author)
        expect(last_notification.action).to     eql(:create)
        expect(last_notification.notifiable).to eql(answer)
      end
    end
  end

  context 'with question from slido' do
    let!(:teacher) { create :teacher }
    let!(:student) { create :user }
    let!(:question) { create :question, author: User.find_by(login: :slido) }
    let!(:question_2) { create :question, author: User.find_by(login: :slido) }
    let!(:answered_question) { create :question, :with_answers, author: User.find_by(login: :slido) }
    let!(:answer) { create :answer, author: teacher, question: question_2 }

    it 'adds first answer to slido question by teacher' do
      login_as teacher

      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by teacher' do
      login_as teacher

      visit root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds first answer to slido question by student' do
      login_as student

      visit root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'My neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it 'adds next answer to slido question by student' do
      login_as student

      visit root_path

      click_link 'Otázky'
      click_link answered_question.title

      fill_in 'answer_text', with: 'My next neat solution'

      click_button 'Odpovedať'

      expect(page).to have_content('Odpoveď bola úspešne pridaná.')
      expect(page).not_to have_css(".answer-labeling-best a.answer-labeled-best")
    end

    it "keeps best label after saving existing answer" do
      login_as teacher

      visit root_path

      click_link 'Otázky'
      click_link question_2.title

      expect(page).to have_css(".answer-labeling-best a.answer-labeled-best")

      answer.save

      expect(page).to have_css(".answer-labeling-best a.answer-labeled-best")
    end
  end
end
