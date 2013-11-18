require 'spec_helper'

describe 'Show Questions' do
  let(:user) { create :user }
  let(:category) { create :category }
  let(:tag) { tag :tag }
  let(:question) {create :question, author: user, category: category}

  context 'with current user' do
    before :each do
      login_as user
    end
    it 'Show new questions' do
      visit root_path

     click_link 'Zobrazenie nových otázok'

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.author)
      expect(page).to have_content(question.category.name)
      end
    end
end
