require 'spec_helper'

describe 'Question Polling', js: true do
  let(:user) { create :user }
  let!(:question) { create :question, tag_list: 'elasticsearch' }

  before :each do
    Configuration.poll.default = 1

    login_as user
  end

  after :each do
    Configuration.poll.default = 60
  end

  it 'refreshes the list of questions by default' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    expect(last_event.data[:params]).not_to include(:poll)

    create :question, title: 'Elasticsearch problem'

    wait_for_remote 2.seconds

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej než minútou')

    expect(last_event.data[:params]).to include(poll: 'true')
  end

  it 'refreshes list of filtered questions' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    expect(last_event.data[:params]).not_to include(:poll)

    fill_in_select2 'question_tags', with: 'elasticsearch'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    expect(last_event.data[:params]).to include(poll: 'true')

    create :question, title: 'Elasticsearch problem', tag_list: 'elasticsearch'

    wait_for_remote 2.seconds

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej než minútou')

    expect(last_event.data[:params]).to include(poll: 'true')
  end

  it 'stops refreshing' do
    visit root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list).to have(1).items

    create :question, title: 'Elasticsearch problem'

    expect(last_event.data[:params]).not_to include(:poll)

    wait_for_remote 2.seconds

    list = all('#questions > ol > li')
    expect(list).to have(2).items

    expect(page).to have_content('Elasticsearch problem')

    click_link 'Aktualizované pred menej než minútou'

    within '#questions-controls' do
      expect(page).to have_content('Aktualizovať automaticky')
    end

    create :question, title: 'Another Elasticsearch problem'

    wait_for_remote 2.seconds

    list = all('#questions > ol > li')

    expect(list).to have(2).items
    expect(page).not_to have_content('Another Elasticsearch problem')

    expect(last_event.data[:params]).not_to include(:poll)
  end
end
