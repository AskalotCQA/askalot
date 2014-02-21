class CreateAnswerRevisions < ActiveRecord::Migration
  def change
    create_table :answer_revisions do |t|
      t.references :answer,   null: false
      t.references :editor,   null: false

      t.text :text, null: false

      t.timestamps
    end

    add_index :answer_revisions, :answer_id
    add_index :answer_revisions, :editor_id
  end
end
