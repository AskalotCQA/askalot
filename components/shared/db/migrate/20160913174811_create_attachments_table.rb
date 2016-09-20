class CreateAttachmentsTable < ActiveRecord::Migration
  def up
    create_table :attachments do |t|
      t.attachment :file
      t.references :attachmentable, null: false, polymorphic: true
      t.references :author, null: false

      t.boolean :deleted, null: false, default: false
      t.references :deletor, null: true
      t.timestamp :deleted_at

      t.timestamps
    end

    add_index :attachments, :author_id
    add_index :attachments, :deletor_id

    add_column :users, :attachments_count, :integer
  end

  def down
    drop_table :attachments

    remove_column :users, :attachments_count
  end
end
