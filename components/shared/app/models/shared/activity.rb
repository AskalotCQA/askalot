module Shared
class Activity < ActiveRecord::Base
  include Initiable

  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :'Shared::User'

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(action: :mention).where(resource_type: [Answer, Comment, Evaluation, Labeling, Question], anonymous: false) }

  scope :global,          lambda { unscope(where: :anonymous) }
  scope :of,              lambda { |user| where(initiator: user) }
  scope :by_followees_of, lambda { |user| where(initiator: user.followees.pluck(:followee_id)) }

  symbolize :action, in: ACTIONS

  self.table_name = 'activities'

  def self.data(user, period: nil, from: nil, to: nil, time: Time.now)
    period ||= (from || time - 1.year)..(to || time)

    data = unscope(:where).of(user).where(created_on: period).group(:created_on).count

    data.inject({}) { |result, (date, count)| result.tap { result[date.to_time.to_i] = count }}
  end
end
end
