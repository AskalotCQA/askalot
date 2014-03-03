class AnswerRevision < ActiveRecord::Base
  belongs_to :answer
  belongs_to :editor, class_name: :User

  def self.create_revision_by!(editor, answer)
    r = AnswerRevision.new
    r.editor = editor
    r.answer = answer
    r.text = answer.text
    r.save!
  end

end
