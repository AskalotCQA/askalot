module Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watchings, as: :watchable, dependent: :destroy
    has_many :watchers, through: :watchings, source: :watcher

    scope :watched, lambda { joins(:watchings).uniq }
  end

  def watched_by?(user)
    watchers.exists?(id: user.id)
  end

  def toggle_watching_by!(user)
    watching = watchings.unscoped.find_or_create_by!(watcher: user, watchable: self)

    if watching.deleted?
      watching.unmark_as_deleted!
    else
      watching.mark_as_deleted_by! user
    end

    watching
  end
end
