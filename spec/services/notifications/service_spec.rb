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

      expect(notifier).to receive(:publish).with(:action, user, resource)

      Notifications::Service.notify(:action, user, resource)
    end
  end

  describe '.subscribe' do
    it 'subscribes a notifier' do
      notifier = double(:notifier)

      Notifications::Service.subscribe(notifier)

      expect(Notifications::Service.notifiers).to include(notifier)
    end
  end

  describe '.unsubscribe' do
    it 'unsubscribes a notifier' do
      notifier = double(:notifier)
      mailer   = double(:mailer)

      Notifications::Service.subscribe(notifier)
      Notifications::Service.subscribe(mailer)

      Notifications::Service.unsubscribe(mailer)

      expect(Notifications::Service.notifiers).to     include(notifier)
      expect(Notifications::Service.notifiers).not_to include(mailer)
    end
  end
end
