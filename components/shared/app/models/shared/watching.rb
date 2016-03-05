module Shared
class Watching < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :watcher, class_name: :'Shared::User'

  belongs_to :watchable, -> { unscope where: :deleted }, polymorphic: true

  default_scope { where(context: Shared::Context::Manager.current_context) if Shared::Watching.column_names.include? 'context' }

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
  scope :in_context, lambda { |context| where(context: context) }

  self.table_name = 'watchings'
end
end
