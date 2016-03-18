class CorrectUniquesOnLabelingsAndTaggings < ActiveRecord::Migration
  def change
    remove_index :labelings, name: 'index_labelings_on_unique_key'

    add_index :labelings, [:deleted, :answer_id, :label_id, :author_id], name: 'index_labelings_on_unique_key', unique: true
    add_index :taggings,  [:deleted, :question_id, :tag_id, :author_id], name: 'index_taggings_on_unique_key',  unique: true
  end
end
