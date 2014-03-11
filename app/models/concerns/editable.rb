module Editable
  extend ActiveSupport::Concern

  included do
    belongs_to :editor, class_name: :User
  end

  def update_edited!(revision)
    self.editor = revision.editor
    self.edited_at = revision.created_at
    save!
  end
end
