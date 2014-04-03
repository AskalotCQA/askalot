class IndexColumnsOnTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, :author_id
    add_index :taggings, :question_id
  end
end
