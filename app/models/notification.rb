class Notification < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User

  belongs_to :resource, -> { unscope where: :deleted }, polymorphic: true

  default_scope -> { where.not(resource_type: [View, Vote]) }

  scope :for, lambda { |user| where(recipient: user) }
  scope :by,  lambda { |user| where(initiator: user) }

  scope :of, lambda { |resource| where(resource: resource) }

  scope :read,   lambda { where(unread: false) }
  scope :unread, lambda { where(unread: true) }

  symbolize :action, in: ACTIONS

  def read=(value)
    self.unread = !value
  end

  def read
    !self.unread
  end

  alias :read? :read

  def mark_as_read
    update unread: false, read_at: Time.now
  end

  def mark_as_unread
    update unread: true, read_at: nil
  end
end
