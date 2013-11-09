require 'spec_helper'

describe 'Add Question' do
  let(:user) { create :user }
  let!(:category) { create :category }

  context 'with current user' do
    before :each do
      login_as user
    end

    it 'adds new question', js: true do
      visit root_path

      click_link 'Opýtať sa otázku'

      fill_in 'question_title', with: ''
      fill_in 'question_text',  with: ''

      click_button 'Vložiť otázku'

      expect(page).to have_content('Nadpis – je povinná položka')
      expect(page).to have_content('Text otázky – je povinná položka')

      fill_in 'question_title', with: 'Lorem ipsum title?'
      fill_in 'question_text',  with: 'Lorem ipsum'

      select category.name, from: 'question_category_id'

      fill_in 'question_tag_list', with: 'tag1 Tag2 tAg3'

      click_button 'Vložiť otázku'

      expect(page).to have_content('Vaša otázka bola úspešne vložená.')

      # TODO (smolnar) remove! use content check for attributes

      expect(Question).to have(1).record

      question = Question.first

      expect(question.title).to eql('Lorem ipsum title?')
      expect(question.text).to eql('Lorem ipsum')
      expect(question.category).to eql(category)
      expect(question.tag_list.sort).to eql(['tag1', 'tag2', 'tag3'])
    end
  end
end
