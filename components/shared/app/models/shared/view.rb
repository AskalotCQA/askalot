module University
class View < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :viewer, class_name: :User, counter_cache: true
  belongs_to :question, counter_cache: true

  scope :by, lambda { |user| where(viewer: user) }

  self.table_name = 'views'

  def to_question
    self.question
  end
end
end
