module Editable
  extend ActiveSupport::Concern

  included do
    belongs_to :editor, class_name: :User

    scope :edited,   lambda { where.not(edited_at: nil) }
    scope :unedited, lambda { where(edited_at: nil) }
  end

  def edited
    self.edited_at.present?
  end

  alias :edited? :edited

  def update_attributes_by_revision(revision)
    return false unless revision

    self.editor    = revision.editor
    self.edited_at = revision.created_at

    self.save!
  end
end
