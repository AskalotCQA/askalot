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

    wait_for_remote 6.seconds

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

    wait_for_remote 6.seconds

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej než minútou')
  end

  it 'stops automatic refreshing' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    click_link 'Aktualizovať automaticky'

    create :question, title: 'Elasticsearch problem'

    wait_for_remote 6.seconds

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')

    click_link 'Aktualizované pred menej než minútou'

    within '#questions-controls' do
      expect(page).to have_content('Aktualizovať automaticky')
    end

    create :question, title: 'Another Elasticsearch problem'

    wait_for_remote 6.seconds

    list = all('#questions > ol > li')

    expect(list).to have(2).items
    expect(page).not_to have_content('Another Elasticsearch problem')
  end
end
