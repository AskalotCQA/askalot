require 'spec_helper'

describe 'Activities', type: :feature do
  let(:user)      { create :user }
  let!(:question) { create :question, :with_tags, author: user }
  let!(:category) { create :category }

  before :each do
    login_as user
  end

  it 'shows activities in context' do
    visit shared.root_path
    click_link 'Otázky'
    click_link question.title
    fill_in 'answer_text', with: 'Hey, look at this.'
    click_button 'Odpovedať'

    visit '/test'

    click_link 'Otázky'
    click_link question.title
    fill_in 'answer_text', with: 'Hey, look at this.'
    click_button 'Odpovedať'

    visit shared.root_path
    click_link 'Aktivita', match: :first

    list = all('.activities li')

    expect(list.size).to eq(1)
  end
end
