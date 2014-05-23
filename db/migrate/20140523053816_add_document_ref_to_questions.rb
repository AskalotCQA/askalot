class AddDocumentRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :document
  end

  add_index :questions, :document_id
end
