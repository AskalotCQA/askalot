class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update]

  belongs_to :initiator, class_name: :User
  belongs_to :resource,  polymorphic: true

  symbolize :action, in: ACTIONS
end
