class RemoveUndeletedTaggingsFromDeletedQuestions < ActiveRecord::Migration
  def up
    Shared::Question.deleted.find_each do |question|
      question.taggings.undeleted.destroy_all
    end
  end

  def down
  end
end
