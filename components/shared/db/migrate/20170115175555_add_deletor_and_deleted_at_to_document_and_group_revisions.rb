class AddDeletorAndDeletedAtToDocumentAndGroupRevisions < ActiveRecord::Migration
  def change
    add_column :document_revisions, :deleted_at, :timestamp
    add_column :group_revisions, :deleted_at, :timestamp
    add_column :document_revisions, :deleted, :boolean, null: false, default: false
    add_column :group_revisions, :deleted, :boolean, null: false, default: false

    add_index :document_revisions, :deleted
    add_index :group_revisions, :deleted

    add_reference :document_revisions, :deletor, null: true, index: true
    add_reference :group_revisions, :deletor, null: true, index: true
  end
end
