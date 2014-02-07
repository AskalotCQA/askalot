require 'spec_helper'

describe 'Add Comment' do
  let(:user) { create :user }
  let!(:question) { create :question, :with_tags }

  before :each do
    login_as user
  end

  it 'adds new comment' do
    visit root_path

    click_link 'Otázky'
    click_link question.title

    click_link 'Pridať komentár'

    click_button 'Komentovať'

    expect(page).to have_content('Komentár – je povinná položka')

    click_link 'Pridať komentár'

    fill_in 'comment[text]', with: 'My comment'

    click_button 'Komentovať'

    expect(page).to have_content('Váš komentár bol úspešne pridaný.')
  end
end
