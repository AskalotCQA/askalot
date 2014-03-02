require 'spec_helper'

describe Notifications::Notifier do
  after :each do
    Notifications::Notifier.factory = nil
  end

  describe '.publish' do
    it 'creates notification' do
      watchers = [double(:watcher1), double(:watcher2)]
      resource = double(:resource, watchers: watchers)
      factory  = double(:factory)

      expect(factory).to receive(:create).with(action: :edit, recipient: watchers.first,  initiator: :user, notifiable: resource)
      expect(factory).to receive(:create).with(action: :edit, recipient: watchers.second, initiator: :user, notifiable: resource)

      Notifications::Notifier.factory = factory
    Notifications::Notifier.publish(:edit, :user, resource)
    end
  end
end
