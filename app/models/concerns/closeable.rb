module Closeable
  extend ActiveSupport::Concern

  included do
    belongs_to :closer, class_name: :User

    scope :closed,   lambda { unscope(where: :closed).where(closed: true) }
    scope :unclosed, lambda { unscope(where: :closed).where(closed: false) }

    after_save do
      mark_as_unclosed! if self.answers.any?
    end
  end

  module ClassMethods
    def closed_or_new(params)
      self.unscope(where: :closed).find_or_initialize_by(params)
    end
  end

  def mark_as_closed_by!(user, time = DateTime.now.in_time_zone)
    self.transaction(requires_new: true) do
      self.closed = true
      closed_changed = self.closed_changed?

      self.closer, self.closed_at = user, time if closed_changed

      self.save!
    end

    self
  end

  def mark_as_unclosed!
    self.transaction do
      self.closed = false

      closed_changed = self.closed_changed?

      self.closer, self.closed_at = nil, nil if deleted_changed

      self.save!
    end

    self
  end

  def toggle_deleted_by!(user)
    if self.new_record? || self.deleted?
      mark_as_undeleted!
    else
      mark_as_deleted_by! user
    end
  end
end
