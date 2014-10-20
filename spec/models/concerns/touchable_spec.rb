require 'spec_helper'

shared_examples_for Touchable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }

  describe 'on update' do
    it 'updates question touched_at attribute' do
      record = build factory

      timestamp = record.to_question.touched_at
      record.save!

      expect(record.to_question.touched_at).not_to eql(timestamp)

      record = create factory
      timestamp = record.to_question.touched_at

      record.text += 'some additional text'
      record.save!

      expect(record.to_question.touched_at).not_to eql(timestamp)
    end

    it 'does not update question touched_at attribute when voting, viewing, favoring' do
      record        = create factory
      old_timestamp = record.to_question.touched_at
      user          = create :user

      record.toggle_voteup_by! user          if record.respond_to? :toggle_voteup_by!
      record.votes_count += 1                if record.respond_to? :votes_count
      record.votes_difference += 1           if record.respond_to? :votes_difference
      record.votes_lb_wsci_bp += 1           if record.respond_to? :votes_lb_wsci_bp
      record.views_count += 1                if record.respond_to? :views_count
      record.toggle_favoring_by! user        if record.respond_to? :toggle_favoring_by!
      record.toggle_labeling_by! user, :best if record.respond_to? :toggle_labeling_by!

      raise "Record does not respond to anything" unless record.changed?

      expect(record.to_question.touched_at).to eql(old_timestamp)
    end
  end
end
