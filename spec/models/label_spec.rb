require 'spec_helper'

describe Label do
  it 'requires value' do
    label = build :label, value: nil

    expect(label).not_to be_valid

    label = build :label, value: :label

    expect(label).to be_valid
  end
end
