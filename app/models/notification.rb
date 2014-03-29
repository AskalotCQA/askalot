class Notification < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User

  #TODO(zbell) rm this shit when on rails 4.1.0, see deletable.rb
  belongs_to :resource, -> { self.included_modules.include?(Deletable) ? self.deleted_or_not : self }, polymorphic: true

  default_scope -> { where.not(resource_type: [View, Vote]) }

  scope :for, lambda { |user| where(recipient: user) }
  scope :by,  lambda { |user| where(initiator: user) }

  scope :of, lambda { |resource| where(resource: resource) }

  scope :read,   lambda { where(unread: false) }
  scope :unread, lambda { where(unread: true) }

  symbolize :action, in: ACTIONS

  def read
    !self.unread
  end

  alias :read? :read
end
