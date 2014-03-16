class Notification < ActiveRecord::Base
  ACTIONS = [:create, :update, :delete, :mention]

  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User
  belongs_to :notifiable, polymorphic: true

  scope :read,   lambda { where(unread: false) }
  scope :unread, lambda { where(unread: true) }

  symbolize :action, in: ACTIONS
end
