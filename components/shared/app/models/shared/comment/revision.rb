module Shared
class Comment
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :comment
    belongs_to :editor, class_name: :'Shared::User'

    self.table_name = 'comment_revisions'

    def self.create_revision!(editor, comment)
      revision         = Comment::Revision.new
      revision.editor  = editor
      revision.comment = comment
      revision.text    = comment.text

      revision.save!
      revision
    end
  end
end
end
