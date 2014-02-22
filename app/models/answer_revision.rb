class AnswerRevision < ActiveRecord::Base
  belongs_to :answer
  belongs_to :editor, class_name: :User
end
