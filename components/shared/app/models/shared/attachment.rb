module Shared
  class Attachment < ActiveRecord::Base
    include Authorable
    include Deletable

    belongs_to :attachmentable, polymorphic: true

    has_attached_file :file,
                      path: "#{Rails.root}/public/attachments/:id-:filename",
                      url: "/attachments/:id-:filename"

    validates_attachment_content_type :file, content_type: /(\Aimage)|(\Atext)/, message: I18n.t('errors.messages.attachment_content_type')
    validates_attachment_size :file, less_than: 2.megabytes


    self.table_name = 'attachments'

    def to_question
      self.attachmentable.to_question
    end
  end
end
