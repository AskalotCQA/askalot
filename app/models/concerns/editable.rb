module Editable
  extend ActiveSupport::Concern

  included do
    belongs_to :editor, class_name: :User
  end

  def update_attributes_by_revision(revision)
    return false unless revision

    self.editor    = revision.editor
    self.edited_at = revision.created_at

    self.save!
  end
end
