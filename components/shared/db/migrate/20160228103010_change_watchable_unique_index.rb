class ChangeWatchableUniqueIndex < ActiveRecord::Migration
  def change
    remove_index :watchings, name: 'index_watchings_on_unique_key'
    add_index :watchings, [:watcher_id, :watchable_id, :watchable_type, :context], name: 'index_watchings_on_unique_key', unique: true
  end
end
