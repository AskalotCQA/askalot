class AddVotesCountToAnswersAndQuestions < ActiveRecord::Migration
  def change
    add_column :answers,   :votes_count, :integer, null: false, default: 0
    add_column :questions, :votes_count, :integer, null: false, default: 0

    add_index :answers,   :votes_count
    add_index :questions, :votes_count
  end
end
