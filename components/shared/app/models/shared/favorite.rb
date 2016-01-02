module Shared
class Favorite < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :favorer, class_name: :'Shared::User', counter_cache: true
  belongs_to :question, counter_cache: true

  scope :by, lambda { |user| where(favorer: user) }

  self.table_name = 'favorites'

  def to_question
    self.question
  end
end
end
