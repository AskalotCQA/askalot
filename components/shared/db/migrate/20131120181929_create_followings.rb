class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :follower, null: false
      t.references :followee, null: false

      t.timestamps
    end

    add_index :followings, :follower_id
    add_index :followings, :followee_id
  end
end
