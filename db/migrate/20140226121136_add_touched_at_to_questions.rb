class AddTouchedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :touched_at, :datetime, null: false, default: '2000-01-01 00:00:00'

    Question.find_each do |question|
      dates  = [question.updated_at]
      dates += question.answers.pluck(:updated_at)
      dates += question.comments.pluck(:updated_at)

      question.answers.each { |a| dates += a.comments.pluck(:updated_at) }

      question.touched_at = dates.max

      question.save!
    end
  end
end
