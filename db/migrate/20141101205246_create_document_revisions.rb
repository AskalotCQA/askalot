class CreateDocumentRevisions < ActiveRecord::Migration
  def change
    create_table :document_revisions do |t|
      t.references :document, null: false
      t.references :editor,   null: false

      t.string :title,   null: false
      t.text   :text, null: false

      t.timestamps
    end

    add_index :document_revisions, :document_id
    add_index :document_revisions, :editor_id
  end
end
