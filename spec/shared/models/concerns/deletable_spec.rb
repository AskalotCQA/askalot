require 'spec_helper'

shared_examples_for Shared::Deletable do
  let(:model) { described_class }
  let(:factory) { model.name.demodulize.underscore.to_sym }
  let(:resource) { create factory }
  let(:deleted_resource) { create factory, :deleted }

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

  describe '.mark_as_undeleted!' do
    it 'set deleted, deletor and deleted_at attribute' do
      expect(deleted_resource.deleted).to eql(true)
      expect(deleted_resource.deletor).not_to eql(nil)
      expect(deleted_resource.deleted_at).not_to eql(nil)

      deleted_resource.mark_as_undeleted!

      expect(deleted_resource.deleted).to eql(false)
      expect(deleted_resource.deletor).to eql(nil)
      expect(deleted_resource.deleted_at).to eql(nil)
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

  describe '.increment_counter_caches!' do
    let!(:deleted_comment) { create :comment, :deleted, commentable: resource }
    let!(:comment) { 10.times.map { create :comment, commentable: resource } }

    it 'increment cache counter after undeleting comment' do
      resource.class.reset_counters resource.id, :comments
      resource.reload

      expect(resource.comments_count).to eql(10)
      expect(resource.comments.count).to eql(10)

      deleted_comment.mark_as_undeleted!

      expect(resource.comments_count).to eql(11)
      expect(resource.comments.count).to eql(11)
    end
  end

  describe '.decrement_counter_caches!' do
    let!(:comment_for_deleting) { create :comment, commentable: resource }
    let!(:comment) { 10.times.map { create :comment, commentable: resource } }

    it 'decrement cache counter after deleting comment' do
      resource.reload

      user = create :user
      now = DateTime.now.in_time_zone

      expect(resource.comments_count).to eql(11)
      expect(resource.comments.count).to eql(11)

      comment_for_deleting.mark_as_deleted_by!(user, now)

      expect(resource.comments_count).to eql(10)
      expect(resource.comments.count).to eql(10)
    end
  end

  describe '.set delete attributes' do
    let!(:comment) { create :comment, commentable: resource }

    it 'sets deletor only if undeleted' do
      user = create :user
      other = create :user

      resource.mark_as_deleted_by!(user)
      resource.mark_as_deleted_by!(other)

      expect(resource.deletor).to eql(user)
    end

    it 'sets deleted_at only if undeleted' do
      user = create :user
      now = DateTime.now.in_time_zone

      resource.mark_as_deleted_by!(user, now)
      resource.mark_as_deleted_by!(user, now + 60.seconds)

      expect(resource.deleted_at.to_s).to eql(now.to_s)
    end

    it 'sets deletor only for undeleted children' do
      user  = create :user
      other = create :user

      comment.mark_as_deleted_by!(user)
      resource.mark_as_deleted_by!(other)
      comment.reload

      expect(comment.deletor).to eql(user)
      expect(resource.deletor).to eql(other)
    end

    it 'sets delete_at only for undeleted children' do
      user = create :user
      now = DateTime.now.in_time_zone

      comment.mark_as_deleted_by!(user, now)
      resource.mark_as_deleted_by!(user, now + 60.seconds)
      comment.reload

      expect(comment.deleted_at.to_s).to eql(now.to_s)
      expect(resource.deleted_at.to_s).to eql((now + 60.seconds).to_s)
    end
  end
end
