require 'spec_helper'

describe 'Notifications' do
  let(:user)      { create :user }
  let!(:question) { create :question, :with_tags }
  let!(:category) { create :category }
  let(:watcher)   { create :user }
  let(:tag)       { create :tag }

  before :each do
    login_as user
  end

  context 'with category' do
    it 'notifies watchers about new question' do
      category.toggle_watching_by!(watcher)

      visit root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Question.last

      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.recipient).to  eql(watcher)
      expect(last_notification.action).to     eql(:create)
      expect(last_notification.notifiable).to eql(question)
    end
  end

  context 'with tag' do
    it 'notifies watchers about new question' do
      tag.toggle_watching_by!(watcher)

      visit root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title',    with: 'Lorem ipsum?'
      fill_in 'question_text',     with: 'Lorem ipsum'
      fill_in 'question_tag_list', with: tag.name

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Question.last

      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.recipient).to  eql(watcher)
      expect(last_notification.action).to     eql(:create)
      expect(last_notification.notifiable).to eql(question)
    end
  end

  context 'with answer' do
    it 'notifies watchers about new answer' do
      question.toggle_watching_by!(question.author)

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
        question.toggle_watching_by!(question.author)

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
        question.toggle_watching_by!(question.author)

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
