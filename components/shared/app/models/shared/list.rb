module Shared
  class List < ActiveRecord::Base
    include Shared::Deletable
    include Shared::Notifiable

    belongs_to :lister, class_name: :'Shared::User', counter_cache: true
    belongs_to :category, counter_cache: true

    scope :by, lambda { |user| where(lister: user) }

    self.table_name = 'lists'

    def to_question
      self.question
    end
  end
end
