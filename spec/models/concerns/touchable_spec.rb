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
    end
  end
end
