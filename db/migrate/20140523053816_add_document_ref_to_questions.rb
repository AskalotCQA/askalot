class AddDocumentRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :document, null: true, index: true
  end
end
