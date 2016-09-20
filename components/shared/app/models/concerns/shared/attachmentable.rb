module Shared::Attachmentable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, class_name: :'Shared::Attachment', as: :attachmentable, dependent: :destroy

    validates_associated_bubbling :attachments, message: nil
  end
end
