require 'spec_helper'

describe University::Notification do
  it 'requires action' do
    notification = build :notification, action: nil

    expect(notification).not_to be_valid

    notification.action = University::Notification::ACTIONS.first

    expect(notification).to be_valid
  end
end
