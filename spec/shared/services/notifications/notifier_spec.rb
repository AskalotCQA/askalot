require 'spec_helper'

describe Shared::Notifications::Notifier do
  after :each do
    Shared::Notifications::Notifier.factory = nil
  end

  describe '.publish' do
    it 'creates notification' do
      watchers = [double(:watcher1), double(:watcher2)]
      resource = double(:resource, watchers: watchers)
      factory  = double(:factory)
      context  = Shared::Context::Manager.current_context_id

      expect(watchers.first).to receive(:alumni?).and_return(false)
      expect(watchers.second).to receive(:alumni?).and_return(false)

      expect(factory).to receive(:create!).with(action: :edit, recipient: watchers.first,  initiator: :user, resource: resource, anonymous: false, context: context)
      expect(factory).to receive(:create!).with(action: :edit, recipient: watchers.second, initiator: :user, resource: resource, anonymous: false, context: context)

      Shared::Notifications::Notifier.factory = factory
      Shared::Notifications::Notifier.publish(:edit, :user, resource)
    end

    it 'provides custom recipients for notification' do
      watcher  = double(:watcher)
      resource = double(:resource)
      factory  = double(:factory)
      context  = Shared::Context::Manager.current_context_id

      expect(watcher).to receive(:alumni?).and_return(false)
      expect(factory).to receive(:create!).with(action: :edit, recipient: watcher, initiator: :user, resource: resource, anonymous: false, context: context)

      Shared::Notifications::Notifier.factory = factory
      Shared::Notifications::Notifier.publish(:edit, :user, resource, for: watcher)
    end

    context 'with duplicated recipient' do
      it 'creates only one notification' do
        watcher  = double(:watcher)
        resource = double(:resource)
        factory  = double(:factory)
        context  = Shared::Context::Manager.current_context_id

        expect(watcher).to receive(:alumni?).and_return(false)
        expect(factory).to receive(:create!).with(action: :edit, recipient: watcher, initiator: :user, resource: resource, anonymous: false, context: context).once

        Shared::Notifications::Notifier.factory = factory
        Shared::Notifications::Notifier.publish(:edit, :user, resource, for: [watcher, watcher])
      end
    end

    context 'when initiator is recipent' do
      it 'ommits notification for initiator' do
        initiator = double(:initiator)
        resource  = double(:resource, watchers: [initiator])
        factory   = double(:factory)

        Shared::Notifications::Notifier.factory = factory
        Shared::Notifications::Notifier.publish(:edit, initiator, resource)
      end
    end
  end
end
