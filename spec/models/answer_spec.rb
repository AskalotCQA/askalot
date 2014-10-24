require 'spec_helper'

require 'models/concerns/editable_spec'
require 'models/concerns/deletable_spec'
require 'models/concerns/touchable_spec'

describe Answer do
  it_behaves_like Editable
  it_behaves_like Deletable
  it_behaves_like Touchable

  it 'requires text' do
    answer = build :answer, text: nil

    expect(answer).not_to be_valid

    answer = build :answer, text: 'My answer'

    expect(answer).to be_valid
  end

  describe Touchable do
    it 'does not update questions touched_at attribute when voting or labeling' do
      answer        = create :answer
      old_timestamp = answer.to_question.touched_at.to_i
      user          = create :user

      answer.toggle_voteup_by! user
      answer.votes_count += 1
      answer.votes_difference += 1
      answer.votes_lb_wsci_bp += 1
      answer.toggle_labeling_by! user, :best

      expect(answer.to_question.touched_at.to_i).to eql(old_timestamp)
    end
  end
  # TODO(zbell) pridat testy pre toggle_labeling_by!
end
