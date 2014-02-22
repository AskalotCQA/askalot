class CommentRevision < ActiveRecord::Base
  belongs_to :comment
  belongs_to :editor, class_name: :User
end
