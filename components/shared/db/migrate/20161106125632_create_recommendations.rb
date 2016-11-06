class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :question, index: true, null: false
      t.references :user, index: true, null: false
      t.timestamp :clicked_at

      t.timestamps
    end
  end

  def down
    drop_table :recommendations
  end
end
