require 'spec_helper'

require 'models/concerns/editable_spec'
require 'models/concerns/deletable_spec'
require 'models/concerns/touchable_spec'

describe Answer do
  #it_behaves_like Editable
  #it_behaves_like Deletable
  #it_behaves_like Touchable

  it_behaves_like Answers::Searchable

  #it 'requires text' do
  #  answer = build :answer, text: nil
  #
  #  expect(answer).not_to be_valid
  #
  #  answer = build :answer, text: 'My answer'
  #
  #  expect(answer).to be_valid
  #end
  # TODO(zbell) pridat testy pre toggle_labeling_by!
end
