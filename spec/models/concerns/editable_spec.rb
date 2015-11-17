require 'spec_helper'

shared_examples_for Shared::Editable do
  let(:model) { described_class }
  let(:factory) { model.name.demodulize.underscore.to_sym }
  let(:editor) { create :user }

  describe '#create_revision!' do
    it 'updates attributes by revision' do
      editable = build factory

      revision = "#{model.name}::Revision".constantize.create_revision!(editor, editable)

      old_editor = editable.editor
      old_edited_at = editable.edited_at

      editable.update_attributes_by_revision revision

      expect(editable.editor).not_to eql(old_editor)
      expect(editable.edited)
      expect(editable.edited_at).not_to eql(old_edited_at)
      expect(revision).to be_persisted
    end
  end
end

