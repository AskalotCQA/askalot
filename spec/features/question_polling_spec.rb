require 'spec_helper'

describe 'Question Polling', js: true do
  let(:user) { create :user }
  let!(:question) { create :question, tag_list: 'elasticsearch' }

  before :each do
    login_as user
  end

  it 'refreshes the list of questions each five seconds' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    click_link 'Aktualizovať automaticky'

    create :question, title: 'Elasticsearch problem'

    sleep 6

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej než minútou')
  end

  it 'refreshes list of filtered questions' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    click_link 'Aktualizovať automaticky'

    fill_in_select2 'question_tags', with: 'elasticsearch'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    create :question, title: 'Elasticsearch problem', tag_list: 'elasticsearch'

    sleep 6

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej než minútou')
  end
end
