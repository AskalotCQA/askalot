module Shared
  class ContextUser < ActiveRecord::Base
    self.table_name = 'context_users'

    belongs_to :user

    validates :context_id, presence: true

    scope :in_context, lambda { |context| where(context_id: context ) }
  end
end
