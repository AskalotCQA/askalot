require 'spec_helper'

describe 'Show Questions', type: :feature, js: true do
  let(:user) { create :user }

  let!(:answered_questions) { 4.times.map { |q| create :question, :with_tags, :with_answers, author: user }  }
  let(:answered_question)  { answered_questions.last }

  let!(:favored_questions) { 3.times.map { |q| create :question, :with_tags, author: user }  }
  let(:favored_question)  { favored_questions.last }

  let!(:newest_questions) { 10.times.map { create :question, :with_tags, author: user } }
  let(:newest_question) { newest_questions.last }

  before :each do
    login_as user
  end

  it 'shows list of all questions' do
    visit shared.root_path

    click_link 'Otázky'

    within '#questions-controls' do
      click_link 'Všetky'

      wait_for_remote
    end

    list = all('#questions > ol > li')

    expect(list.size).to eq(17)

    within list[0] do
      expect(page).to have_content(newest_question.title)
      expect(page).to have_content(newest_question.category.name)

      newest_question.tags.pluck(:name).each do |tag|
        expect(page).to have_content(tag)
      end
    end
  end

  it 'shows list of active questions' do
    visit shared.root_path

    click_link 'Otázky'

    within '#questions-controls' do
      click_link 'Aktívne'

      wait_for_remote
    end

    list = all('#questions > ol > li')

    expect(list.size).to eq(17)

    within list[0] do
      expect(page).to have_content(newest_question.title)
      expect(page).to have_content(newest_question.category.name)

      newest_question.tags.pluck(:name).each do |tag|
        expect(page).to have_content(tag)
      end
    end
  end

  it 'shows list of answered questions' do
    visit shared.root_path

    click_link 'Otázky'

    within '#questions-controls' do
      click_link 'Odpovedané'

      wait_for_remote
    end

    list = all('#questions > ol > li')

    expect(list.size).to eq(4)

    within list[0] do
      expect(page).to have_content(answered_question.title)
      expect(page).to have_content(answered_question.category.name)

      answered_question.tags.pluck(:name).each do |tag|
        expect(page).to have_content(tag)
      end
    end
  end

  it 'shows list of favored questions' do
    favored_questions.each { |q| q.toggle_favoring_by! user }

    visit shared.root_path

    click_link 'Otázky'

    within '#questions-controls' do
      click_link 'Obľúbené'

      wait_for_remote
    end

    list = all('#questions > ol > li')

    expect(list.size).to eq(3)

    within list[0] do
      expect(page).to have_content(favored_question.title)
      expect(page).to have_content(favored_question.category.name)

      favored_question.tags.pluck(:name).each do |tag|
        expect(page).to have_content(tag)
      end
    end
  end

  it 'shows list of unanswered questions' do
    skip
  end

  it 'shows list of solved questions' do
    skip
  end
end
