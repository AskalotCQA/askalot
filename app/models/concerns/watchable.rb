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
    return watchings.create! watcher: user unless watched_by?(user)

    watchings.where(watcher: user).first.destroy!
  end
end
