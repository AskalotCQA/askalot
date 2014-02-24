class AddDeletedToAnswersAndQuestionsAndComments < ActiveRecord::Migration
  def change
    add_column :answers,   :deleted, :boolean, null: false, default: false
    add_column :questions, :deleted, :boolean, null: false, default: false
    add_column :comments,  :deleted, :boolean, null: false, default: false

    add_index :answers,   :deleted
    add_index :questions, :deleted
    add_index :comments,  :deleted

  end
end
