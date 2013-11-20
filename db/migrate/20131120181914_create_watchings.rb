class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.references :watcher,   null: false
      t.references :watchable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :watchings, :watcher_id
    add_index :watchings, [:watchable_id, :watchable_type]
  end
end
