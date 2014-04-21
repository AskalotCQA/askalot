class Activity < ActiveRecord::Base
  include Initiable

  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(action: :mention).where(resource_type: [Answer, Comment, Evaluation, Question], anonymous: false) }

  symbolize :action, in: ACTIONS

  def self.global
    Activity.all.unscope(where: :anonymous)
  end
end
