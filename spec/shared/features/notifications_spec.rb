require 'spec_helper'

describe 'Notifications', type: :feature do
  let(:user)      { create :user }
  let!(:question) { create :question, :with_tags }
  let!(:category_parent_parent) { create :category, parent: Shared::Category.last }
  let!(:category_parent) { create :category, parent: category_parent_parent }
  let!(:category) { create :category, askable: true, parent: category_parent }

  let(:watcher)   { create :user }
  let(:tag)       { create :tag }

  before :each do
    login_as user
  end

  context 'with category' do
    it 'notifies watchers about new question' do
      category.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Shared::Question.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(watcher)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(question)

      click_link 'Odhlásiť', match: :first

      login_as watcher

      expect(page).to have_xpath("//a[text()='1 neprečítaná notifikácia']/../../descendant::img[@alt='#{user.nick}']")
    end

    it 'notifies parent category watchers about new question' do
      category_parent.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Shared::Question.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(watcher)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(question)

      click_link 'Odhlásiť', match: :first

      login_as watcher

      expect(page).to have_xpath("//a[text()='1 neprečítaná notifikácia']/../../descendant::img[@alt='#{user.nick}']")
    end

    it 'notifies parent category watchers about new question 2' do
      category_parent_parent.toggle_watching_by!(watcher)
      category_parent.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Shared::Question.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(watcher)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(question)

      click_link 'Odhlásiť', match: :first

      login_as watcher

      expect(page).to have_xpath("//a[text()='1 neprečítaná notifikácia']/../../descendant::img[@alt='#{user.nick}']")

      click_link 'Odhlásiť', match: :first

      login_as user

      category_parent_parent.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum2?'
      fill_in 'question_text',  with: 'Lorem ipsum2'

      click_button 'Opýtať'

      expect(notifications.size).to eql(2)

      question = Shared::Question.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(watcher)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(question)

      click_link 'Odhlásiť', match: :first

      login_as watcher

      expect(page).to have_xpath("//a[text()='2 neprečítané notifikácie']/../../descendant::img[@alt='#{user.nick}']")

      click_link 'Odhlásiť', match: :first

      login_as user

      category_parent.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum3?'
      fill_in 'question_text',  with: 'Lorem ipsum3'

      click_button 'Opýtať'

      expect(notifications.size).to eql(2)

      question = Shared::Question.last

      expect(last_notification.resource).not_to eql(question)

      click_link 'Odhlásiť', match: :first

      login_as watcher

      expect(page).to have_xpath("//a[text()='2 neprečítané notifikácie']/../../descendant::img[@alt='#{user.nick}']")
    end

    context 'with anonymous question' do
      it 'notifies watchers about new question and hides asker' do
        category.toggle_watching_by!(watcher)

        visit shared.root_path

        click_link 'Opýtať sa otázku'

        select category.name, from: 'question_category_id'

        fill_in 'question_title', with: 'Lorem ipsum?'
        fill_in 'question_text',  with: 'Lorem ipsum'
        check 'question_anonymous'

        click_button 'Opýtať'

        expect(notifications.size).to eql(1)

        click_link 'Odhlásiť', match: :first

        login_as watcher

        expect(page).to have_xpath('//a[text()="1 neprečítaná notifikácia"]/../../descendant::img[@alt="anonymous"]')
      end
    end
  end

  context 'with tag' do
    it 'notifies watchers about new question' do
      tag.toggle_watching_by!(watcher)

      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select category.name, from: 'question_category_id'

      fill_in 'question_title',    with: 'Lorem ipsum?'
      fill_in 'question_text',     with: 'Lorem ipsum'
      fill_in 'question_tag_list', with: tag.name

      click_button 'Opýtať'

      expect(notifications.size).to eql(1)

      question = Shared::Question.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(watcher)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(question)
    end
  end

  context 'with answer' do
    it 'notifies watchers about new answer' do
      question.toggle_watching_by!(question.author)

      visit shared.root_path

      click_link 'Otázky'
      click_link question.title

      fill_in 'answer_text', with: 'Hey, look at this.'

      click_button 'Odpovedať'

      expect(notifications.size).to eql(1)

      answer = Shared::Answer.last

      expect(last_notification.initiator).to eql(user)
      expect(last_notification.recipient).to eql(question.author)
      expect(last_notification.action).to    eql(:create)
      expect(last_notification.resource).to  eql(answer)
    end
  end

  context 'with comment' do
    context 'for question' do
      it 'notifies about new comment' do
        question.toggle_watching_by!(question.author)

        visit shared.root_path

        click_link 'Otázky'
        click_link question.title

        within '#question-comments' do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(notifications.size).to eql(1)

        comment = Shared::Comment.last

        expect(last_notification.resource).to  eql(comment)
        expect(last_notification.recipient).to eql(question.author)
        expect(last_notification.initiator).to eql(user)
        expect(last_notification.action).to    eql(:create)
      end
    end

    context 'for answer' do
      let!(:answer) { create :answer, question: question }

      it 'registers commenter as watcher of the question' do
        visit shared.root_path

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

        visit shared.root_path

        click_link 'Otázky'
        click_link question.title

        within "#answer-#{answer.id}" do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(notifications.size).to eql(1)

        comment = Shared::Comment.last

        expect(last_notification.resource).to  eql(comment)
        expect(last_notification.recipient).to eql(question.author)
        expect(last_notification.initiator).to eql(user)
        expect(last_notification.action).to    eql(:create)
      end
    end
  end

  context 'when following' do
    let!(:followee) { create :user }

    it 'notifies folowee about new follower' do
      visit shared.root_path

      all(:link, text: 'Používatelia').first.click
      all(:link, text: followee.nick).first.click

      click_link 'Nasledovať'

      expect(notifications.size).to eql(1)

      following = Shared::Following.last

      expect(last_notification.resource).to eql(following)
      expect(last_notification.recipient).to eql(followee)
      expect(last_notification.initiator).to eql(user)
      expect(last_notification.action).to eql(:create)
    end
  end

  context 'notification marking' do
    it 'marks notification as read/unread using AJAX', js: true do
      notification_1 = create :notification, recipient: user, action: :create, resource: question, context: Shared::Context::Manager.current_context_id
      notification_2 = create :notification, recipient: user, action: :create, resource: question, context: Shared::Context::Manager.current_context_id

      visit shared.root_path

      within '.navbar-right .dropdown', match: :first do
        click_link '2'
      end

      notifications = all('.dropdown-notification')
      expect(notifications.size).to eq(2)

      within "#dropdown-notification-#{notification_1.id}" do
        all('.btn-xs.pull-right')[0].click
      end

      expect(page).to have_css('.notification-read')

      notification_1.reload
      notification_2.reload

      expect(notification_1.read).to eql(true)
      expect(notification_2.read).to eql(false)

      within "#dropdown-notification-#{notification_1.id}" do
        all('.btn-xs.pull-right')[0].click
      end

      expect(page).not_to have_css('.notification-read')

      notification_1.reload
      notification_2.reload

      expect(notification_1.read).to eql(false)
      expect(notification_2.read).to eql(false)

      within '.navbar-right .dropdown', match: :first do
        click_link 'Označiť všetky ako prečítané'
      end

      expect(page).to have_css('.notification-read')

      notification_1.reload
      notification_2.reload

      expect(notification_1.read).to eql(true)
      expect(notification_2.read).to eql(true)
    end
  end
end
