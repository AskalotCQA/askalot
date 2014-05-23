class AddDocumentRefToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :document
  end

  add_index :answers, :document_id
end
