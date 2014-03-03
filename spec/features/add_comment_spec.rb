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

  context 'for question' do
    context 'with notifications' do
      it 'registers commenter as watcher of question' do
        visit root_path

        click_link 'Otázky'
        click_link question.title

        within '#question-comments' do
          click_link 'Pridať komentár'

          fill_in 'comment[text]', with: 'So wanna watch this!'

          click_button 'Komentovať'
        end

        expect(question).to be_watched_by(user)
      end

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
        expect(last_notification.action).to     eql(:'add-comment')
      end
    end
  end

  context 'for answer' do
    let!(:answer) { create :answer, question: question }

    context 'with notifications' do
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
        expect(last_notification.action).to     eql(:'add-comment')
      end
    end
  end

  context 'when using markdown' do
    it 'renders only links and mentions' do
      other = create :user, login: :smolnar

      visit root_path

      click_link 'Otázky'
      click_link question.title

      within '#question-comments' do
        click_link 'Pridať komentár'

        fill_in 'comment[text]', with: '# Hey, @smolnar, check out [askalot](https://askalot.fiit.stuba.sk).'

        click_button 'Komentovať'
      end

      within '#question-comments' do
        expect(page).not_to have_css('h1')
        expect(page).to     have_content('Hey, @smolnar, check out askalot.')

        expect(page).to     have_link('@smolnar', href: user_path(:smolnar))
        expect(page).to     have_link('askalot',  href: 'https://askalot.fiit.stuba.sk')
      end

      expect(notifications.size).to eql(1)

      comment = Comment.last

      expect(last_notification.notifiable).to eql(comment)
      expect(last_notification.recipient).to  eql(other)
      expect(last_notification.initiator).to  eql(user)
      expect(last_notification.action).to     eql(:'mention-user')
    end
  end
end
