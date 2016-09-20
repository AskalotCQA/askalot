require 'spec_helper'

describe 'Add Attachment', type: :feature do
  let(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  after :each do
    Shared::Attachment.unscoped.each do |a|
      a.file.clear
      a.save
    end
  end

  it 'adds new question with attachment' do
    visit shared.root_path

    click_link 'Opýtať sa otázku'

    attach_file('attachments[]', test_fixture_path('shared/attachments/image.ps'))

    click_button 'Opýtať'

    expect(page).to have_content('Prílohy – Súbor – musí byť obrázok, čistý text, PDF alebo PPT')

    fill_in 'question_title', with: 'Lorem ipsum title?'
    fill_in 'question_text',  with: 'Lorem ipsum'

    select category.name, from: 'question_category_id'

    attach_file('attachments[]', test_fixture_path('shared/attachments/image.jpg'))

    click_button 'Opýtať'

    expect(page).to have_content('Otázka bola úspešne pridaná.')

    expect(Shared::Attachment.count).to eq(1)

    within '.question-attachments' do
      expect(page).to have_content('image.jpg')
    end
  end

  it 'adds new answer with attachment' do
    visit shared.question_path(question)

    attach_file('attachments[]', test_fixture_path('shared/attachments/image.ps'))

    click_button 'Odpovedať'

    expect(page).to have_content('Prílohy – Súbor – musí byť obrázok, čistý text, PDF alebo PPT')

    fill_in 'answer_text',  with: 'Lorem ipsum'

    attach_file('attachments[]', test_fixture_path('shared/attachments/image.jpg'))

    click_button 'Odpovedať'

    expect(page).to have_content('Odpoveď bola úspešne pridaná.')

    expect(Shared::Answer.count).to eq(1)
    expect(Shared::Attachment.count).to eq(1)

    within '.answer-attachments' do
      expect(page).to have_content('image.jpg')
    end
  end
end
