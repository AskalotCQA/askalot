class IndexTaggingsOnQuestionId < ActiveRecord::Migration
  def change
    add_index :taggings, :question_id
    add_index :taggings, [:tag_id, :question_id] # TODO (smolnar) cannot create unique index since some records might be marked as deleted
  end
end
