module Deletable
  extend ActiveSupport::Concern

  included do
    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }
  end

  def mark_as_deleted!(deletion)
    deletion.deleted = true
    deletion.save!
  end
end
