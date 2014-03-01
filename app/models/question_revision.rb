class QuestionRevision < ActiveRecord::Base
  belongs_to :question
  belongs_to :editor, class_name: :User

  def self.create_by!(editor, question)
    r = QuestionRevision.new

    r.category = question.category.name
    r.tags = []
    r.tags.append(question.category.name)
    r.editor = editor
    question.tags.each do |t|
      r.tags.append(t.name)
    end
    r.title = question.title
    r.text = question.text
    r.question = question

    r.save!
  end
end
