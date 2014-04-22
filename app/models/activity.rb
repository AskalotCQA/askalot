class Activity < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(action: :mention).where(resource_type: [Answer, Comment, Evaluation, Question]) }

  scope :of, lambda { |user| where(initiator: user) }

  symbolize :action, in: ACTIONS

  def self.data(user, period: nil, from: nil, to: nil, time: Time.now)
    period ||= (from || time - 1.year)..(to || time)

    data = unscope(:where).of(user).where(created_on: period).group(:created_on).count

    data.inject({}) { |result, (date, count)| result.tap { result[date.to_time.to_i] = count }}
  end
end
