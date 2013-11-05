require 'spec_helper'

describe 'Show questions' do
  let(:question) {create :question}

    it 'shows questions' do
      visit root_path

      click_link 'Show questions'

      expect(page).to have_content(question.title)
  end
end
