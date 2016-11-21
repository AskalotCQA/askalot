class AddDeletorAndDeletedAtToEvaluationRevisions < ActiveRecord::Migration
  def change
    add_column :evaluation_revisions, :deleted, :boolean, null: false, default: false
    add_index :evaluation_revisions, :deleted

    add_reference :evaluation_revisions, :deletor, null: true, index: true
    add_column :evaluation_revisions, :deleted_at, :timestamp
  end
end
