module Deletable
  extend ActiveSupport::Concern

  included do
    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }
  end

  def mark_as_deleted!
    self.deleted = true

    self.save!
  end
end
