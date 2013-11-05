class CreateQuestionTaggings < ActiveRecord::Migration
  def change
    create_table :question_taggings do |t|
      t.integer :question_id
      t.integer :tag_id

      t.timestamps
    end

    add_index :question_taggings, :question_id
    add_index :question_taggings, :tag_id
  end
end
