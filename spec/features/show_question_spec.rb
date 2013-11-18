require 'spec_helper'

describe 'Show Question' do
  let(:question) { create :question, title: 'PostgreSQL setup' }

  before :each do
    login_as question.author
  end

  it 'shows new question' do
    visit root_path

    click_link 'Otázky'

    click_link 'PostgreSQL setup'

    expect(page).to have_content('PostgreSQL setup')
    expect(page).to have_content(question.text)
    expect(page).to have_content(question.author.nick)
  end
end
