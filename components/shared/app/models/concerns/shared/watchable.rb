module Shared::Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watchings, class_name: :'Shared::Watching', as: :watchable, dependent: :destroy
    has_many :watchers, through: :watchings, source: :watcher

    scope :watched, lambda { joins(:watchings).uniq }
  end

  def watched_by?(user)
    watchers.exists?(id: user.id)
  end

  def toggle_watching_by!(user)
    watchings.deleted_or_new(watcher: user, watchable: self, context: Shared::Context::Manager.current_context).toggle_deleted_by! user
  end
end
