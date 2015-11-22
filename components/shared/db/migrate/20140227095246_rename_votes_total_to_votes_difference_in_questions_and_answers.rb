class RenameVotesTotalToVotesDifferenceInQuestionsAndAnswers < ActiveRecord::Migration
  def change
    rename_column :questions, :votes_total, :votes_difference
    rename_column :answers,   :votes_total, :votes_difference
  end
end
