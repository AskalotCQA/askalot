class RenameUpvoteToPositiveInVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :upvote, :positive
  end
end
