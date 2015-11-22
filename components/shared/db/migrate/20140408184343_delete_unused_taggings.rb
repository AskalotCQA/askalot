class DeleteUnusedTaggings < ActiveRecord::Migration
  def up
    Shared::Tagging.where(author_id: nil).each do |tagging|
      question = Shared::Question.unscoped.where(id: tagging.question_id).first

      if question
        tagging.update_attributes!(author_id: question.author_id)
      else
        tagging.destroy!
      end
    end
  end

  def down
  end
end
