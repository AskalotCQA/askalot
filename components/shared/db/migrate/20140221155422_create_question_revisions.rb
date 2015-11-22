class CreateQuestionRevisions < ActiveRecord::Migration
  def change
    create_table :question_revisions do |t|
      t.references :question, null: false
      t.references :editor,   null: false

      t.string :category, null: false
      t.string :tags,     null: false, array: true
      t.string :title,    null: false
      t.text   :text,     null: false

      t.timestamps
    end

    add_index :question_revisions, :editor_id
    add_index :question_revisions, :question_id
  end
end
