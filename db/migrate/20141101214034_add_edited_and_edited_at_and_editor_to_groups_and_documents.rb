class AddEditedAndEditedAtAndEditorToGroupsAndDocuments < ActiveRecord::Migration
  def change
    add_column :groups,    :edited, :boolean, null: false, default: false
    add_column :documents, :edited, :boolean, null: false, default: false

    add_column :groups,    :edited_at, :datetime, null: true
    add_column :documents, :edited_at, :datetime, null: true

    add_reference :groups,    :editor, null: true
    add_reference :documents, :editor, null: true

    add_index :groups,    :edited
    add_index :documents, :edited
  end
end
