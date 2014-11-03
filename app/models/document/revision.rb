class Document
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :document
    belongs_to :editor, class_name: :User

    def self.create_revision!(editor, document)
      revision          = Document::Revision.new
      revision.editor   = editor
      revision.document = document
      revision.title    = document.title
      revision.text     = document.text

      revision.save!
      revision
    end
  end
end
