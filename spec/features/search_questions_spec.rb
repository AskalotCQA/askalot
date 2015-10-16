require 'spec_helper'

describe 'Search Questions' do
  let!(:user) { create :user }

  before :each do
    Question.autoimport = true
    Question.probe.index.reload

    login_as user

    create :question, title: 'Elasticsearch scripts', text: 'Can I use facets with scripts?'
    create :question, title: 'Elasticsearch request fails', text: 'Elasticsearch fails upon request.'
    create :question, title: 'PostgreSQL features', text: 'How to add a extension to PostgreSQL?'
  end

  it 'searches questions by title' do
    visit questions_path

    all('.fulltext-switch a').first.click

    within '#fulltext-search' do
      fill_in 'q', with: 'Elasticsearch'

      click_button 'Vyhľadať'
    end

    list = all('#questions ol > li')

    expect(list.size).to eq(2)

    within '#questions' do
      expect(page).to have_content('Elasticsearch scripts')
      expect(page).to have_content('Elasticsearch request fails')
    end
  end

  it 'searches questions by texts' do
    visit questions_path

    all('.fulltext-switch a').first.click

    within '#fulltext-search' do
      fill_in 'q', with: 'extension'

      click_button 'Vyhľadať'
    end

    list = all('#questions ol > li')

    expect(list.size).to eq(1)

    within '#questions' do
      expect(page).to have_content('PostgreSQL features')
    end
  end

  it 'searches questions by answers' do
    pending
  end

  it 'searches questions by comments' do
    pending
  end

  it 'searches questions by evaluations' do
    pending
  end
end
