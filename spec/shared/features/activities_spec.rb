require 'spec_helper'

describe 'Activities', type: :feature do
  let(:user)      { create :user }
  let!(:question) { create :question, :with_tags, author: user, created_at: Time.now - 10.minutes }
  let!(:category) { create :category }

  before :each do
    login_as user
  end

  context 'when asking question' do
    it 'creates an activity', js: true do
      visit shared.root_path

      click_link 'Opýtať sa otázku'

      select2 category.name, from: 'question_category_id'

      fill_in 'question_title', with: 'Lorem ipsum?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      click_button 'Opýtať'

      activity = user.activities.last

      expect(activity.resource).to  eql(Shared::Question.last)
      expect(activity.action).to    eql(:create)
      expect(activity.initiator).to eql(user)
    end

    context 'when answering' do
      it 'creates an activity' do
        visit shared.root_path

        click_link 'Otázky'
        click_link question.title

        fill_in 'answer_text', with: 'Hey, look at this.'

        click_button 'Odpovedať'

        activity = user.activities.last

        expect(activity.resource).to  eql(Shared::Answer.last)
        expect(activity.action).to    eql(:create)
        expect(activity.initiator).to eql(user)
      end
    end

    context 'when editing question', js: true do
      it 'creates an activity' do
        visit shared.root_path

        click_link 'Otázky'
        click_link question.title

        click_link "question-#{question.id}-edit-modal"

        within "#question-#{question.id}-editing" do
          fill_in 'question_title', with: 'Elasticsearch problem'
          fill_in 'question_text',  with: 'I have a problem with Elasticsearch Client in Ruby.'

          fill_in_select2 'question_tag_list', with: 'elasticsearch'
          fill_in_select2 'question_tag_list', with: 'ruby'

          click_button 'Uložiť'
        end

        activity = user.activities.last

        expect(activity.resource).to  eql(question)
        expect(activity.action).to    eql(:update)
        expect(activity.initiator).to eql(user)
      end
    end
  end
end
