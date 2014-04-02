class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User
  belongs_to :resource,  polymorphic: true

  default_scope -> { where.not(resource_type: [View, Vote]) }

  symbolize :action, in: ACTIONS
end

