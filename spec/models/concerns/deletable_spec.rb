require 'spec_helper'

shared_examples_for Deletable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }
  let(:resource) { create factory }

  describe '.mark_as_deleted_by!' do
    it 'set deleted, deletor and deleted_at atribute' do
      user = create :user
      now = DateTime.now.in_time_zone

      resource.mark_as_deleted_by!(user)

      expect(resource.deleted).to eql(true)
      expect(resource.deletor).to eql(user)
      expect(resource.deleted_at.to_s).to eql(now.to_s)
    end
  end
end

