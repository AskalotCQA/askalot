class Notification < ActiveRecord::Base
  belongs_to :recipient,  class_name: :User
  belongs_to :initiator,  class_name: :User
  belongs_to :notifiable, polymorphic: true

  symbolize :action, in: [:'new-answer']
end
