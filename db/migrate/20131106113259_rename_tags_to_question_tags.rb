class RenameTagsToQuestionTags < ActiveRecord::Migration
  def self.up
    rename_table :tags, :question_tags

    rename_column :question_taggings, :tag_id, :question_tag_id
  end

  def self.down
    rename_table :question_tags, :tags

    rename_column :question_taggings, :question_tag_id, :tag_id
  end
end
