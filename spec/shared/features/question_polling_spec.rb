require 'spec_helper'

describe 'Question Polling', type: :feature, js: true do
  let(:user) { create :user }
  let!(:question) { create :question, tag_list: 'elasticsearch' }

  before :each do
    Shared::Configuration.poll.default = 5

    login_as user
  end

  it 'refreshes the list of questions by default' do
    visit shared.root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list.size).to eq(1)

    expect(last_event.data[:params]).not_to include(:poll)

    create :question, title: 'Elasticsearch problem'

    wait_for_questions_polling

    list = all('#questions > ol > li')
    expect(list.size).to eq(2)

    expect(page).to have_content('Elasticsearch problem')
    expect(page).to have_content('Aktualizované pred menej ako minútou')

    expect(last_event.data[:params]).to include(poll: 'true')
  end

  it 'stops refreshing' do
    visit shared.root_path

    click_link 'Otázky'

    list = all('#questions > ol > li')
    expect(list.size).to eq(1)

    create :question, title: 'Elasticsearch problem'

    expect(last_event.data[:params]).not_to include(:poll)

    wait_for_questions_polling

    list = all('#questions > ol > li')
    expect(list.size).to eq(2)

    expect(page).to have_content('Elasticsearch problem')

    click_link 'Aktualizované pred menej ako minútou'

    within '#questions-controls' do
      expect(page).to have_content('Aktualizovať automaticky')
    end

    create :question, title: 'Another Elasticsearch problem'

    wait_for_questions_polling

    list = all('#questions > ol > li')

    expect(list.size).to eq(2)
    expect(page).not_to have_content('Another Elasticsearch problem')

    expect(last_event.data[:params]).to include(poll: 'false')
  end
end
