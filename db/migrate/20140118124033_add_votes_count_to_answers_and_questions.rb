class AddVotesCountToAnswersAndQuestions < ActiveRecord::Migration
  def change
    add_column :answers,   :votes_total, :integer, null: false, default: 0
    add_column :questions, :votes_total, :integer, null: false, default: 0

    add_index :answers,   :votes_total
    add_index :questions, :votes_total
  end
end
