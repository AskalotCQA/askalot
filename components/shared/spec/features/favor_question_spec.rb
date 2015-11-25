require 'spec_helper'

describe 'Favor Question' do
  let(:user)      { create :user }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  context 'when user is not a favorer' do
    it 'favors the question', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link "question-#{question.id}-favor"

      wait_for_remote

      expect(question).to be_favored_by(user)
    end
  end

  context 'when user is already a favorer' do
    before :each do
      question.toggle_favoring_by! user
    end

    it 'unfavors the question', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      click_link "question-#{question.id}-favor"

      wait_for_remote

      expect(question).not_to be_favored_by(user)
    end
  end
end
