require 'spec_helper'

describe Notifications::Dispatcher do
  let(:notifier) { double(:notifier) }

  after :each do
    Notifications::Dispatcher.unsubscribe_all
  end

  describe '.notify' do
    before :each do
      Notifications::Dispatcher.subscribe(notifier)
    end

    it 'publishes changes using subscribed notifiers' do
      resource = double(:resource)
      user     = double(:user)

      expect(notifier).to receive(:publish).with(:action, user, resource)

      Notifications::Dispatcher.notify(:action, user, resource)
    end
  end

  describe '.subscribe' do
    it 'subscribes a notifier' do
      notifier = double(:notifier)

      Notifications::Dispatcher.subscribe(notifier)

      expect(Notifications::Dispatcher.notifiers).to include(notifier)
    end
  end

  describe '.unsubscribe' do
    it 'unsubscribes a notifier' do
      notifier = double(:notifier)
      mailer   = double(:mailer)

      Notifications::Dispatcher.subscribe(notifier)
      Notifications::Dispatcher.subscribe(mailer)

      Notifications::Dispatcher.unsubscribe(mailer)

      expect(Notifications::Dispatcher.notifiers).to     include(notifier)
      expect(Notifications::Dispatcher.notifiers).not_to include(mailer)
    end
  end
end
