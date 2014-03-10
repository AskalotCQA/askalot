class AddDeletedToVotesAndEvaluationsAndViews < ActiveRecord::Migration
  def change
    add_column :evaluations, :deleted, :boolean, null: false, default: false
    add_column :labelings,   :deleted, :boolean, null: false, default: false
    add_column :views,       :deleted, :boolean, null: false, default: false
    add_column :votes,       :deleted, :boolean, null: false, default: false

    add_index :evaluations, :deleted
    add_index :labelings,   :deleted
    add_index :views,       :deleted
    add_index :votes,       :deleted
  end
end
