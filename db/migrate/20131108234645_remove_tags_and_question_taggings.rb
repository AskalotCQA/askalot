class RemoveTagsAndQuestionTaggings < ActiveRecord::Migration
  def change
    drop_table :question_tags
    drop_table :question_taggings
  end
end
