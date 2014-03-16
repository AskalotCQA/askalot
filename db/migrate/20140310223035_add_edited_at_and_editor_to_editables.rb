class AddEditedAtAndEditorToEditables < ActiveRecord::Migration
  def change
    add_column :questions, :edited_at, :datetime, null: true
    add_column :answers,   :edited_at, :datetime, null: true
    add_column :comments,  :edited_at, :datetime, null: true

    add_reference :questions, :editor, null: true
    add_reference :answers,   :editor, null: true
    add_reference :comments,  :editor, null: true
  end
end
