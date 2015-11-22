class CreateEvaluationRevisions < ActiveRecord::Migration
  def change
    create_table :evaluation_revisions do |t|
      t.references :evaluation, null: false
      t.references :editor,     null: false

      t.text    :text
      t.integer :value, null: false

      t.timestamps
    end

    add_index :evaluation_revisions, :evaluation_id
    add_index :evaluation_revisions, :editor_id
  end
end
