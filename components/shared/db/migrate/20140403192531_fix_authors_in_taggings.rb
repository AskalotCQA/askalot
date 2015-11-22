class FixAuthorsInTaggings < ActiveRecord::Migration
  def up
    Shared::Question.unscoped.find_each do |question|
      Shared::Tagging.unscoped.where(question_id: question).each do |tagging|
        tagging.update_attributes!(author_id: question.author_id)
      end
    end
  end

  def down
  end
end
