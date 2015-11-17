module University
class Watching < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :watcher, class_name: :User

  belongs_to :watchable, -> { unscope where: :deleted }, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }

  self.table_name = 'watchings'
end
end
