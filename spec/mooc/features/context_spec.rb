require 'spec_helper'

describe 'Context filtering', type: :feature do
  let(:user)           { create :user }
  let(:user2)          { create :user }
  let!(:category)      { create :category }
  let!(:other_context) { create :category, parent_id: nil }

  before :each do
    login_as user

    @context_category = Shared::Context::Manager.context_category
    @category = Shared::Category.find(@context_category.id).leaves.first
  end

  describe 'determine context' do
    it 'redirects to url with context if not set' do
      visit shared.questions_path

      uri = URI.parse(current_url)
      expect(uri.path).to eql(shared.questions_path(context_uuid: @context_category.uuid))
    end
  end

  context 'for activities' do
    it 'shows activities in context' do
      question = create :question, :with_tags, author: user, category: @category

      visit shared.question_path question

      fill_in 'answer_text', with: 'Hey, look at this.'
      click_button 'Odpovedať'

      category = Shared::Category.create name: 'test'
      question = create :question, :with_tags, author: user, category: category

      visit shared.question_path(question, context_uuid: category.uuid)

      fill_in 'answer_text', with: 'Hey, look at this.'
      click_button 'Odpovedať'

      visit "/#{@context_category.uuid}"
      click_link 'Aktivita', match: :first

      list = all('.activities li')

      expect(list.size).to eq(1)
    end
  end

  context 'for notifications' do
    it 'shows activities in context' do
      question = create :question, :with_tags, author: user2, category: @category

      question.toggle_watching_by!(user2)

      visit shared.question_path question

      fill_in 'answer_text', with: 'Hey, look at this.'
      click_button 'Odpovedať'

      within :css, '.user-menu-dropdown' do
        find('a.dropdown-toggle').click
      end

      within :css, '.user-menu-dropdown' do
        click_link 'Odhlásiť'
      end

      login_as user2

      visit shared.root_path context_uuid: other_context.uuid
      expect(page).to have_xpath('//a[@data-track-label="0-unread"]')

      visit shared.notifications_path context_uuid: other_context.uuid

      expect(page).to have_content('Žiadne notifikácie.')

      visit shared.root_path context_uuid: @context_category.uuid
      expect(page).to have_xpath('//a[text()="1 neprečítaná notifikácia"]')

      visit shared.notifications_path context_uuid: @context_category.uuid

      notifications = all('#unread > ol.notifications > li')

      expect(notifications.size).to eq(1)
    end
  end

  context 'for watchings' do
    it 'shows watchings in context' do
      question = create :question, :with_tags, author: user2, category: @category

      question.toggle_watching_by!(user)

      visit shared.watchings_path context_uuid: other_context.uuid

      expect(page).to have_content('Žiadne sledovania.')

      visit shared.watchings_path context_uuid: @context_category.uuid

      watchings = all('ol.watchings > li')

      expect(watchings.size).to eq(1)
    end
  end

  context 'for users' do
    it 'shows users in context' do
      Shared::ContextUser.create user: user, context_id: @context_category.id

      visit shared.users_path

      list = all('#users .user-square')

      expect(list.size).to eq(2)

      category = Shared::Category.create name: 'test', uuid: 'test_uuid'

      visit shared.users_path context_uuid: category.uuid

      list = all('#users .user-square')

      expect(list.size).to eq(0)
    end
  end

  context 'for tags' do
    it 'shows tags in context' do
      create :question, :with_tags, author: user2, category: @category

      visit shared.tags_path

      list = all('#tags h4')

      expect(list.size).to eq(1)

      category = Shared::Category.create name: 'test', uuid: 'test_uuid'

      visit shared.tags_path context_uuid: category.uuid

      list = all('#tags h4')

      expect(list.size).to eq(0)
    end
  end

  context 'for user profile' do
    it 'shows user profile items in context' do
      question = create :question, :with_tags, author: user, category: @category
      category = create :category, parent_id: nil

      create :answer, author: user
      question.toggle_favoring_by! user

      visit shared.question_path question

      fill_in 'answer_text', with: 'Hey, look at this.'
      click_button 'Odpovedať'

      visit shared.user_path(user.nick)

      within '.tab-navigation' do
        click_link 'Otázky'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(1)

      within '.tab-navigation' do
        click_link 'Odpovede'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(2)

      within '.tab-navigation' do
        click_link 'Obľúbené'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(1)

      within '.tab-navigation' do
        click_link 'Aktivita'
      end

      list = all('ol.activities > li')

      expect(list.size).to eq(1)

      visit shared.user_path(user.nick, context_uuid: category.uuid)

      within '.tab-navigation' do
        click_link 'Otázky'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(0)

      within '.tab-navigation' do
        click_link 'Odpovede'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(0)

      within '.tab-navigation' do
        click_link 'Obľúbené'
      end

      list = all('.tab-pane.active .question-preview')

      expect(list.size).to eq(0)

      within '.tab-navigation' do
        click_link 'Aktivita'
      end

      list = all('ol.activities > li')

      expect(list.size).to eq(0)
    end
  end
end
