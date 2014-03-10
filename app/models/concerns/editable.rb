module Editable
  extend ActiveSupport::Concern

  def edited_at
    revisions.last.created_at
  end

  def edited_by
    revisions.last.editor
  end
end
