class CommentRevision < ActiveRecord::Base
  belongs_to :comment
  belongs_to :editor, class_name: :User

  def self.create_revision!(editor, comment)
    revision         = CommentRevision.new
    revision.editor  = editor
    revision.comment = comment
    revision.text    = comment.text

    revision.save!
    revision
  end
end
