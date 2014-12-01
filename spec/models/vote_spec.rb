require 'spec_helper'

describe Vote do
  context 'when from stack exchange' do
    it 'requires stack exchange uuid instead of voter' do
      vote = build :vote, voter: nil, stack_exchange_uuid: nil

      expect(vote).not_to be_valid

      vote = build :vote, voter: nil, stack_exchange_uuid: 12

      expect(vote).to be_valid
    end
  end

  context 'when from askalot' do
    it 'requires stack exchange uuid instead of voter' do
      vote = build :vote, voter: nil, stack_exchange_uuid: nil

      expect(vote).not_to be_valid

      vote = build :vote, stack_exchange_uuid: 12

      expect(vote).to be_valid
    end
  end
end
