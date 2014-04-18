class Watching < ActiveRecord::Base
  #include Deletable # TODO enable
  include Notifiable

  belongs_to :watcher, class_name: :User

  belongs_to :watchable, -> { unscope where: :deleted }, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
end
