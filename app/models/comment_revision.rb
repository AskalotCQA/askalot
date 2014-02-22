class CommentRevision < ActiveRecord::Base
  belongs_to :editor, class_name: :User
  belongs_to :comment

end
