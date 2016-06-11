class AddQuestionTypeToQuestionsRevisions < ActiveRecord::Migration
  def up
    add_column :question_revisions, :question_type, :string
  end

  def down
    remove_column :question_revisions, :question_type
  end
end
