require 'spec_helper'

shared_examples_for Watchable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }
  let(:resource) { create factory }

  describe '#watched_by?' do
    it 'check if the user is watcher' do
      user = create :user

      create :watching, watcher: user, watchable: resource

      expect(resource).to be_watched_by(user)
    end
  end
end
