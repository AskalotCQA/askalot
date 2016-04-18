class AddWithBestAnswerToQuestion < ActiveRecord::Migration
  def up
    add_column :questions, :with_best_answer, :boolean, default: false
    update "UPDATE questions SET with_best_answer = 't' WHERE questions.id IN (SELECT DISTINCT answers.question_id FROM answers WHERE answers.deleted = 'f' AND answers.id IN (SELECT DISTINCT answer_id FROM labelings INNER JOIN labels ON labels.id = labelings.label_id WHERE labels.value = 'best' AND labelings.deleted = 'f'))"
  end

  def down
    remove_column :questions, :with_best_answer
  end
end
