require 'spec_helper'

shared_examples_for Deletable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }
  let(:resource) { create factory }

  before :each do
    Timecop.freeze(Time.now)
  end

  after :each do
    Timecop.return
  end

  describe '.mark_as_deleted_by!' do
    it 'set deleted, deletor and deleted_at attribute' do
      user = create :user
      now = DateTime.now.in_time_zone

      resource.mark_as_deleted_by!(user, now)

      expect(resource.deleted).to eql(true)
      expect(resource.deletor).to eql(user)
      expect(resource.deleted_at.to_s).to eql(now.to_s)
    end
  end

  describe '.mark_as_deleted_recursive!' do
    let!(:comment){ create :comment, commentable: resource }
    let!(:evaluation){ create :evaluation, evaluable: resource }

    it 'find associations and set deleted, deletor and deleted_at attribute' do
      user = create :user
      now = DateTime.now.in_time_zone

      resource.mark_as_deleted_by!(user, now)

      expect(resource.deleted).to eql(true)
      expect(resource.deletor).to eql(user)
      expect(resource.deleted_at.to_s).to eql(now.to_s)

      expect(resource.comments.first.deleted).to eql(true)
      expect(resource.comments.first.deletor).to eql(user)
      expect(resource.comments.first.deleted_at.to_s).to eql(now.to_s)

      expect(resource.evaluations.first.deleted).to eql(true)
      expect(resource.evaluations.first.deletor).to eql(user)
      expect(resource.evaluations.first.deleted_at.to_s).to eql(now.to_s)
    end
  end

  describe '.decrement_counter_caches!' do
    let!(:comment_for_deleting) { create :comment, commentable: resource }
    let!(:comment) {10.times.map { create :comment, commentable: resource } }

    it 'decrement cache counter ofter deleting comment' do
      resource.reload

      user = create :user
      now = DateTime.now.in_time_zone

      comment_for_deleting.mark_as_deleted_by!(user, now)

      expect(resource.comments_count).to eql(10)
    end
  end
end

