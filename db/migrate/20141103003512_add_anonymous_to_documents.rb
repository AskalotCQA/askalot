class AddAnonymousToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :anonymous, :boolean, null: false, default: false

    add_index :documents, :anonymous
  end
end
