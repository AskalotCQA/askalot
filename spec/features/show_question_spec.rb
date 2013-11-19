require 'spec_helper'

describe 'Show Question' do
  let(:question) { create :question }

  it 'show existing questions', js:true do
    visit question_path(:id => question.id)

    expect(page).to have_content('Lorem ipsum')
  end

end
