class CommentRevision < ActiveRecord::Base
  belongs_to :comment
  belongs_to :editor, class_name: :User

  def self.create_by!(editor, comment)
    r = CommentRevision.new

    r.comment = comment
    r.editor = editor
    r.text = comment.text

    r.save!
  end
end
