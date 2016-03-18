class IndexVotesWithStackExchange < ActiveRecord::Migration
  def up
    change_column :votes, :voter_id, :integer, null: true

    remove_index :votes, name: :index_votes_on_unique_key

    add_index :votes, [:voter_id, :votable_id, :votable_type, :stack_exchange_uuid], name: 'index_votes_on_unique_key', unique: true
  end

  def down
    change_column :votes, :voter_id, :integer, null: false

    remove_index :votes, name: :index_votes_on_unique_key

    add_index :votes, [:voter_id, :votable_id, :votable_type], name: 'index_votes_on_unique_key', unique: true
  end
end
