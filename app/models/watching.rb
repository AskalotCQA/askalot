class Watching < ActiveRecord::Base
  include Notifiable

  belongs_to :watcher, class_name: :User

  #TODO(zbell) rm this shit when on rails 4.1.0, see deletable.rb
  belongs_to :watchable, -> { self.included_modules.include?(Deletable) ? self.deleted_or_not : self }, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
end
