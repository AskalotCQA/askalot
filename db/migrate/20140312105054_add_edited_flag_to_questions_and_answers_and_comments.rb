class AddEditedFlagToQuestionsAndAnswersAndComments < ActiveRecord::Migration
  def change
    add_column :answers,   :edited, :boolean, null: false, default: false
    add_column :questions, :edited, :boolean, null: false, default: false
    add_column :comments,  :edited, :boolean, null: false, default: false

    add_index :answers,   :edited
    add_index :questions, :edited
    add_index :comments,  :edited
  end
end
