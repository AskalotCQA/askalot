class View < ActiveRecord::Base
  belongs_to :viewer, class_name: :User, counter_cache: true
  belongs_to :question, counter_cache: true

  scope :by, lambda { |user| where(viewer: user) }
end
