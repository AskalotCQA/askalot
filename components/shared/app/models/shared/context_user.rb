module Shared
  class ContextUser < ActiveRecord::Base
    self.table_name = 'context_users'

    belongs_to :user, class_name: :'Shared::User'
    belongs_to :context, class_name: :'Shared::Category'

    validates :user_id, presence: true
    validates :context_id, presence: true

    after_save { Shared::User.probe.index.import self.user }
  end
end
