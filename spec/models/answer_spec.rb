require 'spec_helper'
require 'models/concerns/touchable_spec'

describe Answer do
  it_behaves_like Touchable

  it 'requires text' do
    answer = build :answer, text: nil

    expect(answer).not_to be_valid

    answer = build :answer, text: 'My answer'

    expect(answer).to be_valid
  end
  # TODO(zbell) pridat testy pre toggle_labeling_by!
end
