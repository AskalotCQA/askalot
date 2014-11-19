class AddDocumentReferenceAndMakeCategoryNotNullInQuestionRevisions < ActiveRecord::Migration
  def change
    add_reference :question_revisions, :document, null: true

    change_column :question_revisions, :category, :string, null: true

    add_index :question_revisions, :document_id
  end
end
