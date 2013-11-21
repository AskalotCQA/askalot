require 'spec_helper'

describe 'Favour Question' do
  let(:user) { create :user }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  context 'when user is not a favourer' do
    it 'favours the question', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link 'favour_question'

      wait_for_remote

      expect(question).to be_favoured_by(user)
    end
  end

  context 'when user already a favourer' do
    before :each do
      question.favour_by! user
    end

    it 'unfavours the question', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link 'favour_question'

      wait_for_remote

      expect(question).not_to be_favoured_by(user)
    end
  end
end
