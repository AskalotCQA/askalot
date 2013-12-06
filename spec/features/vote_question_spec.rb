require 'spec_helper'

describe 'Voteup question' do
  let(:question) { create :question, :with_tags, title: 'Voting in democracy' }

  before :each do
    login_as question.author
  end

  it 'vote up', js: true do
    visit root_path

    click_link 'Otázky'

    click_link 'Voting in democracy'

    click_link 'question-voteup'

    wait_for_remote

    expect(question).to be_upvoted_by(question.author)
  end

  it 'vote down', js: true do
    visit root_path

    click_link 'Otázky'

    click_link 'Voting in democracy'

    click_link 'question-votedown'

    wait_for_remote

    expect(question).to be_downvoted_by(question.author)
  end

  it 'cancel vote', js: true do
    visit root_path

    click_link 'Otázky'

    click_link 'Voting in democracy'

    click_link 'question-voteup'

    wait_for_remote

    click_link 'question-voteup'

    wait_for_remote

    expect(question).not_to be_voted_by(question.author)
  end
end
