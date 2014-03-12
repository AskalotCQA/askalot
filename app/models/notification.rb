class Notification < ActiveRecord::Base
  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User
  belongs_to :notifiable, polymorphic: true

  symbolize :action, in: [
    :'create-question',
    :'create-answer',
    :'create-comment',

    :'edit-question',
    :'edit-answer',
    :'edit-comment',

    :'delete-question',
    :'delete-answer',
    :'delete-comment',

    :'mention-user'
  ]
end
