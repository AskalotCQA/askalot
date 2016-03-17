module Shared
  class ContextUser < ActiveRecord::Base
    self.table_name = 'context_users'

    belongs_to :user

    validates :context, presence: true

    scope :in_context, lambda { |context| where(context: context ) }
  end
end
