class AddCounterCachesToFollowables < ActiveRecord::Migration
  def up
    add_counter :users, :followers
    add_counter :users, :followees
  end

  def down
    remove_counter :users, :followers
    remove_counter :users, :followees
  end
end
