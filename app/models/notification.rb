class Notification < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User
  belongs_to :notifiable, polymorphic: true

  default_scope -> { where.not(notifiable_type: [:view, :vote]) }

  scope :for, lambda { |user| where(recipient: user) }
  scope :by,  lambda { |user| where(initiator: user) }

  scope :of, lambda { |resource| where(notifiable: resource) }

  scope :read,   lambda { where(unread: false) }
  scope :unread, lambda { where(unread: true) }

  symbolize :action, in: ACTIONS

  def read
    !self.unread
  end

  alias :read? :read
end
