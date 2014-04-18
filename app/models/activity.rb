class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where(resource_type: [Answer, Comment, Evaluation, Question]) }

  symbolize :action, in: ACTIONS
end
