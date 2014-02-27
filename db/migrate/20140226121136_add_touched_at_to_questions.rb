class AddTouchedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :touched_at, :datetime, null: false, default: '2000-01-01 00:00:00'

    Question.all.each do |question|
      if question.answers.count == 0
        question.touched_at = question.updated_at
      else
        question.answers.each do |answer|
          question.touched_at = answer.updated_at if question.touched_at < answer.updated_at
          answer.comments.each do |comment|
            question.touched_at = comment.updated_at if question.touched_at < comment.updated_at
          end
        end
      end

      question.comments.each do |comment|
        question.touched_at = comment.updated_at if question.touched_at < comment.updated_at
      end

      question.save
    end
  end
end
