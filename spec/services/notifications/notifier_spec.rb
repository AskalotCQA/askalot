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

      expect(factory).to receive(:create!).with(action: :edit, recipient: watchers.first,  initiator: :user, notifiable: resource)
      expect(factory).to receive(:create!).with(action: :edit, recipient: watchers.second, initiator: :user, notifiable: resource)

      Notifications::Notifier.factory = factory
      Notifications::Notifier.publish(:edit, :user, resource)
    end

    it 'provides custom recipients for notification' do
      watcher  = double(:watcher)
      resource = double(:resource)
      factory  = double(:factory)

      expect(factory).to receive(:create!).with(action: :edit, recipient: watcher, initiator: :user, notifiable: resource)

      Notifications::Notifier.factory = factory
      Notifications::Notifier.publish(:edit, :user, resource, for: watcher)
    end

    context 'with duplicated recipient' do
      it 'create only one notification' do
        watcher  = double(:watcher)
        resource = double(:resource)
        factory  = double(:factory)

        expect(factory).to receive(:create!).with(action: :edit, recipient: watcher, initiator: :user, notifiable: resource).once

        Notifications::Notifier.factory = factory
        Notifications::Notifier.publish(:edit, :user, resource, for: [watcher, watcher])
      end
    end

    context 'when initiator is recipent' do
      it 'ommits notification for initiator' do
        initiator = double(:initiator)
        resource  = double(:resource, watchers: [initiator])
        factory   = double(:factory)

        Notifications::Notifier.factory = factory
        Notifications::Notifier.publish(:edit, initiator, resource)
      end
    end
  end
end
