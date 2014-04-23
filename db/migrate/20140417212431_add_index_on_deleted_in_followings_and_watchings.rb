class AddIndexOnDeletedInFollowingsAndWatchings < ActiveRecord::Migration
  def change
    add_index :followings, :deleted
    add_index :watchings,  :deleted
  end
end
