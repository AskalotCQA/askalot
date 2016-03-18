require 'spec_helper'

describe Shared::Notification, type: :model do
  it 'requires action' do
    notification = build :notification, action: nil

    expect(notification).not_to be_valid

    notification.action = Shared::Notification::ACTIONS.first

    expect(notification).to be_valid
  end
end
