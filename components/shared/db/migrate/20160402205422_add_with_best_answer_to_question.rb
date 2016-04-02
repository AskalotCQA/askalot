class AddWithBestAnswerToQuestion < ActiveRecord::Migration
  def up
    add_column :questions, :with_best_answer, :boolean
    Shared::Question.all.each do |question|
      question.with_best_answer = question.answers.labeled_with(Shared::Label.where(value: :best).first).first.present?
      question.save
    end
  end

  def down
    remove_column :questions, :with_best_answer
  end
end
