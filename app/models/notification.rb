class Notification < ActiveRecord::Base
  belongs_to :recipient, class_name: :User
  belongs_to :initiator, class_name: :User
  belongs_to :notifiable, polymorphic: true

  symbolize :action, in: [:'add-question', :'add-answer', :'add-comment', :'mention-user']
end
