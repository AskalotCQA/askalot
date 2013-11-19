require 'spec_helper'

describe 'Add Answer' do
  let!(:question) { create :question }

  before :each do
    login_as question.author
  end

  it 'adds new answer to question' do
    visit root_path

    click_link 'Otázky'
    click_link question.title

    click_button 'Pridať odpoveď'

    expect(page).to have_content('Text – je povinná položka')

    fill_in 'answer_text', with: 'My neat solution'

    click_button 'Pridať odpoveď'

    expect(page).to have_content('Odpoveď bola úspešne vložená.')
  end
end
