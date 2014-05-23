class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :group, null: false

      t.string :title, null: false

      t.string :document_type
      t.string :content

      t.timestamps
    end

    add_index :documents, :group_id
    add_index :documents, :title
  end
end
