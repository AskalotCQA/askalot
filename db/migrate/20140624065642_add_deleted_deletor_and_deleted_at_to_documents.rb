class AddDeletedDeletorAndDeletedAtToDocuments < ActiveRecord::Migration
  def change
    add_column    :documents, :deleted, :boolean, null: false, default: false
    add_reference :documents, :deletor, null: true, index: true
    add_column    :documents, :deleted_at, :timestamp
  end
end
