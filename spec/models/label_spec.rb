require 'spec_helper'

describe Label do
  it 'requires value' do
    label = create :label, title: nil

    expect(label).not_to be_valid

    label = create :label, title: :label

    expect(label).to be_valid
  end
end
