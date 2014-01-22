class ForceMissingUniques < ActiveRecord::Migration
  def change
    add_index :favorites, [:user_id, :question_id], name: 'index_favorites_on_unique_key', unique: true

    add_index :followings, [:follower_id, :followee_id], name: 'index_followings_on_unique_key', unique: true

    add_index :labelings, [:author_id, :answer_id, :label_id], name: 'index_labelings_on_unique_key', unique: true

    remove_index :labels, :value

    add_index :labels, :value, unique: true

    add_index :votes, [:voter_id, :votable_id, :votable_type], name: 'index_votes_on_unique_key', unique: true

    add_index :watchings, [:watcher_id, :watchable_id, :watchable_type], name: 'index_watchings_on_unique_key', unique: true
  end
end
