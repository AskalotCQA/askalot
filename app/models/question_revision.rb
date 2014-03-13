class QuestionRevision < ActiveRecord::Base
  belongs_to :question
  belongs_to :editor, class_name: :User

  def self.create_revision!(editor, question)
    revision          = QuestionRevision.new
    revision.editor   = editor
    revision.question = question
    revision.category = question.category.name
    revision.tags     = question.labels.map(&:name)
    revision.title    = question.title
    revision.text     = question.text

    revision.save!
    revision
  end
end
