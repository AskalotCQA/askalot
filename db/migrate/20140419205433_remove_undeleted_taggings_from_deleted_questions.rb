class RemoveUndeletedTaggingsFromDeletedQuestions < ActiveRecord::Migration
  def up
    Question.deleted.find_each do |question|
      question.taggings.undeleted.destroy_all
    end
  end
end
