module Shared
class Watching < ActiveRecord::Base
  include Deletable
  include Notifiable

  before_save :default_values

  belongs_to :watcher, class_name: :'Shared::User'

  belongs_to :watchable, -> { unscope where: :deleted }, polymorphic: true

  belongs_to :category, class_name: 'Shared::Category', foreign_key: 'watchable_id'

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
  scope :in_context, lambda { |context| where(context: context) if Rails.module.mooc? }

  self.table_name = 'watchings'

  private

  def default_values
    self.context ||= Shared::Context::Manager.current_context if Shared::Watching.column_names.include? 'context'
  end

  def copy(assingment_id, context)
    watching_copy = self.dup
    watching_copy.watchable_id = assingment_id
    watching_copy.context = context

    watching_copy.save

    watching_copy
  end
end
end
