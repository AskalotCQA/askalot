require 'spec_helper'

describe 'Favour Question' do
  let(:user) { create :user }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  context 'with current user' do
    it 'favours question' do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link 'favour_question'

      expect(user.favoured_questions).to include(question)
    end
  end
end
