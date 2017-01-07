require 'spec_helper'

shared_examples_for Shared::Watchable do
  let(:model) { described_class }
  let(:factory) { model.name.demodulize.underscore.to_sym }
  let(:resource) { create factory }

  describe '#watched_by?' do
    it 'check if the user is watcher' do
      user = create :user

      create :watching, watcher: user, watchable: resource

      expect(resource).to be_watched_by(user)
    end
  end

  describe '#toggle_watching_by!' do
    context 'when user does not watch the resource' do
      it 'registers watching' do
        user = create :user

        resource.toggle_watching_by!(user)

        expect(resource).to be_watched_by(user)
      end
    end

    context 'when user watches the resource' do
      it 'unregisters watching' do
        user = create :user

        create :watching, watcher: user, watchable: resource

        resource.toggle_watching_by!(user)

        expect(resource).not_to be_watched_by(user)
      end
    end
  end
end
