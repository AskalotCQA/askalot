class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(action: :mention).where(resource_type: [Answer, Comment, Evaluation, Question], anonymous: false) }

  scope :private_activities, -> { unscope where: :anonymous }

  symbolize :action, in: ACTIONS
end
