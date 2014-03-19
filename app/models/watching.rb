class Watching < ActiveRecord::Base
  belongs_to :watcher, class_name: :User
  belongs_to :watchable, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
end
