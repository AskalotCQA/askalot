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
    let!(:comment) { create :comment, commentable: resource }
    let!(:evaluation) { create :evaluation, evaluable: resource }

    it 'find associations and set deleted, deletor and deleted_at attribute' do
      user = create :user
      now = DateTime.now.in_time_zone

      resource.mark_as_deleted_by!(user, now)

      comment.reload
      evaluation.reload

      expect(resource.deleted).to eql(true)
      expect(resource.deletor).to eql(user)
      expect(resource.deleted_at.to_s).to eql(now.to_s)

      expect(comment.deleted).to eql(true)
      expect(comment.deletor).to eql(user)
      expect(comment.deleted_at.to_s).to eql(now.to_s)

      expect(evaluation.deleted).to eql(true)
      expect(evaluation.deletor).to eql(user)
      expect(evaluation.deleted_at.to_s).to eql(now.to_s)
    end
  end

  describe '.decrement_counter_caches!' do
    let!(:comment_for_deleting) { create :comment, commentable: resource }
    let!(:comment) { 10.times.map { create :comment, commentable: resource } }

    it 'decrement cache counter ofter deleting comment' do
      resource.reload

      user = create :user
      now = DateTime.now.in_time_zone

      comment_for_deleting.mark_as_deleted_by!(user, now)

      expect(resource.comments_count).to eql(10)
    end
  end

  describe '.set delete attributes' do
    let!(:comment_for_deleting) { create :comment, commentable: resource }
    let!(:comment) { create :comment, commentable: resource }
    let!(:evaluation) { create :evaluation, evaluable: resource }

    it 'sets delete_at only undeleted elements' do
      user = create :user
      now = DateTime.now

      comment_for_deleting.mark_as_deleted_by!(user, now)

      resource.mark_as_deleted_by!(user, now + 1.seconds)

      comment_for_deleting.reload

      expect(comment_for_deleting.deleted_at.to_s).not_to eql(resource.deleted_at.to_s)
      expect(comment_for_deleting.deleted_at.to_s).to eql((resource.deleted_at - 1.seconds).to_s)
    end
  end
end

