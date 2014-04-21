class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(action: :mention).where(resource_type: [Answer, Comment, Evaluation, Question]) }

  scope :of, lambda { |user| where(initiator: user) }

  symbolize :action, in: ACTIONS
end
