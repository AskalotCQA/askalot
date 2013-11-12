require 'spec_helper'

describe 'Show Questions' do
  let(:user) { create :user }
  let(:question) {create :question}

  context 'with current user' do
    before :each do
      login_as user
    end
    it 'Show new questions', js: true do
      visit root_path

      click_link 'Zobrazenie nových otázok'

      expect(page).to have_content(question.title)
      end
    end
end
