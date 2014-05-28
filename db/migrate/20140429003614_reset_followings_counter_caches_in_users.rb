class ResetFollowingsCounterCachesInUsers < ActiveRecord::Migration
  def up
    reset_counter :users, :followees
    reset_counter :users, :followers
  end

  def down
  end
end
