require 'spec_helper'

describe 'Notifications' do
  let(:user)      { create :user }
  let!(:question) { create :question, :with_tags }
  let!(:category) { create :category }

  before :each do
    login_as user
  end

  context 'with question' do
    it 'registers author as watcher' do
      visit root_path

      click_link 'Opýtať sa otázku'

      select  category.name,    from: 'question_category_id'
      fill_in 'question_title', with: 'Am I a watcher or stalker?'
      fill_in 'question_text',  with: 'I want to have notification for this question.'

      click_button 'Opýtať'

      question = Question.last

      expect(question).to be_watched_by(user)
    end
  end

  context 'with answer' do
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

  context 'with comment' do
    context 'for question' do
      it 'notifies about new comment' do
        create :watching, watcher: question.author, watchable: question

        visit root_path

        click_link 'Otázky'
        click_link question.title

        within '#question-comments' do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(notifications.size).to eql(1)

        comment = Comment.last

        expect(last_notification.notifiable).to eql(comment)
        expect(last_notification.recipient).to  eql(question.author)
        expect(last_notification.initiator).to  eql(user)
        expect(last_notification.action).to     eql(:create)
      end
    end

    context 'for answer' do
      let!(:answer) { create :answer, question: question }

      it 'registers commenter as watcher of the question' do
        visit root_path

        click_link 'Otázky'
        click_link question.title

        within "#answer-#{answer.id}" do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(question).to be_watched_by(user)
      end

      it 'notifies about new comment' do
        create :watching, watcher: question.author, watchable: answer

        visit root_path

        click_link 'Otázky'
        click_link question.title

        within "#answer-#{answer.id}" do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(notifications.size).to eql(1)

        comment = Comment.last

        expect(last_notification.notifiable).to eql(comment)
        expect(last_notification.recipient).to  eql(question.author)
        expect(last_notification.initiator).to  eql(user)
        expect(last_notification.action).to     eql(:create)
      end
    end
  end
end
