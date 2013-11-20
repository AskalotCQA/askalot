require 'spec_helper'

describe 'Add Question Answer' do
  let!(:question) { create :question, :with_tags }

  before :each do
    login_as question.author
  end

  it 'adds new answer to question' do
    visit root_path

    click_link 'Otázky'
    click_link question.title

    click_button 'Odpovedať'

    expect(page).to have_content('Odpoveď – je povinná položka')

    fill_in 'answer_text', with: 'My neat solution'

    click_button 'Odpovedať'

    expect(page).to have_content('Vaša odpoveď bola úspešne pridaná.')
  end
end
