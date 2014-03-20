class Watching < ActiveRecord::Base
  belongs_to :watcher, class_name: :User
  belongs_to :watchable, -> { deleted_or_not if respond_to? :deleted_or_not }, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
end
