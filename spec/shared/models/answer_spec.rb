require 'spec_helper'

require_relative 'concerns/editable'
require_relative 'concerns/deletable'
require_relative 'concerns/touchable'

describe Shared::Answer, type: :model do
  it_behaves_like Shared::Editable
  it_behaves_like Shared::Deletable
  it_behaves_like Shared::Touchable

  it 'requires text' do
    answer = build :answer, text: nil

    expect(answer).not_to be_valid

    answer = build :answer, text: 'My answer'

    expect(answer).to be_valid
  end

  describe Shared::Touchable do
    it 'does not update questions touched_at attribute when voting or labeling' do
      answer        = create :answer
      old_timestamp = answer.to_question.touched_at
      user          = create :user

      Timecop.travel(Time.now + 100) do
        answer.toggle_voteup_by! user
        answer.votes_count += 1
        answer.votes_difference += 1
        answer.votes_lb_wsci_bp += 1
        answer.toggle_labeling_by! user, :best
      end

      # always compare timestamps directly, do not round with to_i
      expect(answer.to_question.touched_at).to eql(old_timestamp)
    end
  end

  # TODO(zbell) pridat testy pre toggle_labeling_by!
end
