class QuestionRevision < ActiveRecord::Base
  belongs_to :question
  belongs_to :editor, class_name: :User

  def self.create_revision_by!(editor, question)
    r = QuestionRevision.new
    r.category = question.category.name
    r.tags = [question.category.name]
    question.tags.each do |t|
      r.tags.append(t.name)
    end
    r.editor = editor
    r.title = question.title
    r.text = question.text
    r.question = question
    r.save!
  end
end
