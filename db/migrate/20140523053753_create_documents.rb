class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :group, null: false

      t.string :title, null: false
      t.text   :content, null: false, default: ''

      t.string :document_type, null: false, default: :text

      t.boolean    :deleted, null: false, default: false
      t.references :deletor, null: true
      t.timestamp  :deleted_at

      t.timestamps
    end

    add_index :documents, :group_id
    add_index :documents, :title
    add_index :documents, :deletor_id
  end
end
