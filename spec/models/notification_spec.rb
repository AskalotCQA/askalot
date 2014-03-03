require 'spec_helper'

describe Notification do
  it 'requires action' do
    notification = build :notification, action: nil

    expect(notification).not_to be_valid

    notification.action = :'new-answer'

    expect(notification).to be_valid
  end
end
