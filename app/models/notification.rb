class Notification < ActiveRecord::Base
  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User
  belongs_to :notifiable, polymorphic: true

  scope :read, lambda { where(unread: false) }
  scope :unread, lambda { where(unread: true) }

  symbolize :action, in: [
    :'create-question',
    :'create-answer',
    :'create-comment',

    :'update-question',
    :'update-answer',
    :'update-comment',

    :'delete-question',
    :'delete-answer',
    :'delete-comment',

    :'mention-user'
  ]
end
