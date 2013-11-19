require 'spec_helper'

describe 'Show Questions' do
  let(:questions) { 10.times.map { create :question, :with_tags } }
  let(:question) { questions.first }
  let(:user) { questions.first.author }

  before :each do
    login_as user
  end

  it 'shows list of new questions', js: true do
    visit root_path

    click_link 'Otázky'

    list = all('ol.questions li')

    expect(list).to have(10).items

    within list.first do
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.category.name)

      question.tags.pluck(:name).each do |tag|
        expect(page).to have_content(tag)
      end
    end
  end
end
