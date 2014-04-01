class AddCounterCacheToFollowings < ActiveRecord::Migration
  def self.up
    add_counter :users, :followers
    add_counter :users, :followees
  end

  def self.down
    remove_counter :users, :followers
    remove_counter :users, :followees
  end
end
