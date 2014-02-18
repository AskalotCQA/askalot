class RenameSlidoUuidToSlidoQuestionUuidInQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :slido_uuid,  :slido_question_uuid
  end
end
