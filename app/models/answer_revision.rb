class AnswerRevision < ActiveRecord::Base
  belongs_to :answer
  belongs_to :editor, class_name: :User

  def self.create_revision_by!(editor, answer)
    revision        = AnswerRevision.new

    revision.editor = editor
    revision.answer = answer
    revision.text   = answer.text

    revision.save!
    answer.update_edited! revision
  end
end
