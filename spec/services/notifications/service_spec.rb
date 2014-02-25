require 'spec_helper'

describe Notifications::Service do
  let(:notifier) { double(:notifier) }

  after :each do
    Notifications::Service.unsubscribe_all
  end

  describe '.notify' do
    before :each do
      Notifications::Service.subscribe(notifier)
    end

    it 'publishes changes using subscribed notifiers' do
      resource = double(:resource)
      user     = double(:user)

      expect(notifier).to receive(:publish).with(resource, user, :event)

      Notifications::Service.notify(resource, user, :event)
    end
  end

  describe '.subscribe' do
    it 'subscribes a notifier' do
      notifier = double(:notifier)

      Notifications::Service.subscribe(notifier)

      expect(Notifications::Service.notifiers).to include(notifier)
    end
  end
end
