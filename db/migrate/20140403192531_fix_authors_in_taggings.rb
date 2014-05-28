class FixAuthorsInTaggings < ActiveRecord::Migration
  def up
    Question.unscoped.find_each do |question|
      Tagging.unscoped.where(question_id: question).each do |tagging|
        tagging.update_attributes!(author_id: question.author_id)
      end
    end
  end

  def down
  end
end
