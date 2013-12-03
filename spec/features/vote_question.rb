require 'spec_helper'

describe 'Voteup question' do
  let(:question) { create :question, :with_tags, title: 'Voting in democracy' }

  before :each do
    login_as question.author
  end

  it 'vote up' do
    visit root_path

    click_link 'Otázky'

    click_link 'Voting in democracy'

    within('#question-'+question.id+'-voting > a') do
      click
    end


  end
end
