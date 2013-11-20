require 'spec_helper'

describe Answer do
  it 'requires text' do
    answer = create :answer, text: nil

    expect(answer).not_to be_valid

    answer = create :answer, text: 'My answer'

    expect(answer).to be_valid
  end
end
