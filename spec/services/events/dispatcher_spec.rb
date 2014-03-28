require 'spec_helper'

describe Events::Dispatcher do
  let(:dispatcher) { Class.new { include Events::Dispatcher }.new }
  let(:notifier)   { double(:notifier) }

  describe '.notify' do
    before :each do
      dispatcher.subscribe(notifier)
    end

    it 'publishes changes using subscribed notifiers' do
      resource = double(:resource)
      user     = double(:user)

      expect(notifier).to receive(:publish).with(:action, user, resource, {})

      dispatcher.dispatch(:action, user, resource)
    end
  end

  describe '.subscribe' do
    it 'subscribes a notifier' do
      notifier = double(:notifier)

      dispatcher.subscribe(notifier)

      expect(dispatcher.listeners).to include(notifier)
    end
  end

  describe '.unsubscribe' do
    it 'unsubscribes a notifier' do
      notifier = double(:notifier)
      mailer   = double(:mailer)

      dispatcher.subscribe(notifier)
      dispatcher.subscribe(mailer)

      dispatcher.unsubscribe(mailer)

      expect(dispatcher.listeners).to     include(notifier)
      expect(dispatcher.listeners).not_to include(mailer)
    end
  end
end
