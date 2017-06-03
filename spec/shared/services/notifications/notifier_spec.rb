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

      expect(resource).to receive(:notifications)
      expect(resource).to receive(:created_at).and_return(Time.now)
      expect(factory).to receive(:create!).with(action: :update, recipient: watchers.first,  initiator: :user, resource: resource, anonymous: false, context: context)
      expect(factory).to receive(:create!).with(action: :update, recipient: watchers.second, initiator: :user, resource: resource, anonymous: false, context: context)

      Shared::Notifications::Notifier.factory = factory

      Timecop.travel Time.now + 600 do
        Shared::Notifications::Notifier.publish(:update, :user, resource)
      end
    end

    it 'does not create notification for update if too early after resource creation' do
      watchers = [double(:watcher1), double(:watcher2)]
      resource = double(:resource, watchers: watchers)
      factory  = double(:factory)

      expect(resource).to receive(:created_at).and_return(Time.now)
      expect(factory).not_to receive(:create!)
      expect(factory).not_to receive(:create!)

      Shared::Notifications::Notifier.factory = factory

      Shared::Notifications::Notifier.publish(:update, :user, resource)
    end

    it 'does not create notification for update if too early after resource creation' do
      watchers = [double(:watcher1), double(:watcher2)]
      resource = double(:resource, watchers: watchers)
      factory  = double(:factory)

      relation = [create(:notification, created_at: (Time.now + 600), action: :update, resource_type: 'Shared::Answer', resource_id: 1)]

      expect(relation).to receive(:where).and_return(relation)
      expect(relation).to receive(:order).and_return(relation)

      expect(resource).to receive(:notifications).and_return(relation)
      expect(resource).to receive(:notifications).and_return(relation)
      expect(resource).to receive(:created_at).and_return(Time.now)

      expect(factory).not_to receive(:create!)
      expect(factory).not_to receive(:create!)

      Shared::Notifications::Notifier.factory = factory

      Timecop.travel Time.now + 600 do
        Shared::Notifications::Notifier.publish(:update, :user, resource)
      end
    end

    it 'provides custom recipients for notification' do
      watcher  = double(:watcher)
      resource = double(:resource)
      factory  = double(:factory)
      context  = Shared::Context::Manager.current_context_id

      expect(resource).to receive(:notifications)
      expect(resource).to receive(:created_at).and_return(Time.now)
      expect(watcher).to receive(:alumni?).and_return(false)
      expect(factory).to receive(:create!).with(action: :update, recipient: watcher, initiator: :user, resource: resource, anonymous: false, context: context)

      Shared::Notifications::Notifier.factory = factory

      Timecop.travel Time.now + 600 do
        Shared::Notifications::Notifier.publish(:update, :user, resource, for: watcher)
      end
    end

    context 'with duplicated recipient' do
      it 'creates only one notification' do
        watcher  = double(:watcher)
        resource = double(:resource)
        factory  = double(:factory)
        context  = Shared::Context::Manager.current_context_id

        expect(resource).to receive(:notifications)
        expect(resource).to receive(:created_at).and_return(Time.now)
        expect(watcher).to receive(:alumni?).and_return(false)
        expect(factory).to receive(:create!).with(action: :update, recipient: watcher, initiator: :user, resource: resource, anonymous: false, context: context).once

        Shared::Notifications::Notifier.factory = factory

        Timecop.travel Time.now + 600 do
          Shared::Notifications::Notifier.publish(:update, :user, resource, for: [watcher, watcher])
        end
      end
    end

    context 'when initiator is recipent' do
      it 'ommits notification for initiator' do
        initiator = double(:initiator)
        resource  = double(:resource, watchers: [initiator])
        factory   = double(:factory)

        expect(resource).to receive(:notifications)
        expect(resource).to receive(:created_at).and_return(Time.now)

        Shared::Notifications::Notifier.factory = factory

        Timecop.travel Time.now + 600 do
          Shared::Notifications::Notifier.publish(:update, initiator, resource)
        end
      end
    end
  end
end
