class AddStatisticsCacheToTags < ActiveRecord::Migration
  def change
    add_column :tags, :max_time, :decimal, precision: 20, scale: 6
    add_column :tags, :min_votes_difference, :integer
    add_column :tags, :max_votes_difference, :integer
  end
end
