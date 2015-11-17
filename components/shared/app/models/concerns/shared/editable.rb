module University::Editable
  extend ActiveSupport::Concern

  included do
    belongs_to :editor, class_name: :User

    scope :edited,   lambda { where(edited: true) }
    scope :unedited, lambda { where(edited: false) }
  end

  def update_attributes_by_revision(revision)
    return false unless revision

    self.edited    = true
    self.editor    = revision.editor
    self.edited_at = revision.created_at

    self.save
  end
end
