class QuestionRevision < ActiveRecord::Base
  belongs_to :question
  belongs_to :editor, class_name: :User

  def self.create_revision_by!(editor, question)
    revision          = QuestionRevision.new

    revision.category = question.category.name
    revision.tags     = [question.category.name]
    revision.editor   = editor
    revision.title    = question.title
    revision.text     = question.text
    revision.question = question

    question.tags.each do |t|
      revision.tags.append(t.name)
    end

    revision.save!
  end
end
