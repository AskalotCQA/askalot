class AddDocumentReferenceToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :document, index: true, null: true
  end
end
