class AddEditedAndEditedAtAndEditorToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :edited, :boolean, null: false, default: false

    add_column :evaluations, :edited_at, :datetime, null: true

    add_reference :evaluations, :editor, null: true

    add_index :evaluations, :edited
  end
end
