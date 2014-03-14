require 'spec_helper'

shared_examples_for Editable do
  let(:model) { described_class }
  let(:factory) { model.name.underscore.to_sym }
  let(:editor) { create :user }

  describe 'create revision' do
    it 'update attributes by revision' do
      editable = build factory

      revision = "#{model.name.classify}Revision".constantize.create_revision!(editor, editable)

      old_editor = editable.editor
      old_edited_at = editable.edited_at

      editable.update_attributes_by_revision revision

      expect(editable.editor).not_to eql(old_editor)
      expect(editable.edited_at).not_to eql(old_edited_at)
      expect(revision.persisted?)
    end
  end
end

