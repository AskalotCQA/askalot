class CommentRevision < ActiveRecord::Base
  belongs_to :comment
  belongs_to :editor, class_name: :User

  def self.create_revision_by!(editor, comment)
    revision         = CommentRevision.new

    revision.comment = comment
    revision.editor  = editor
    revision.text    = comment.text

    revision.save!
  end
end
