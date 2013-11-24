class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :voter,   null: false
      t.references :votable, null: false, polymorphic: true

      t.boolean :upvote, null: false, default: true

      t.timestamps
    end

    add_index :votes, :voter_id
    add_index :votes, [:votable_id, :votable_type, :upvote]
    add_imdex :votes, :upvote
  end
end
