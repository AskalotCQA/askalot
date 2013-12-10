module Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watchings, as: :watchable
    has_many :watchers, through: :watchings, source: :watcher
  end
end
