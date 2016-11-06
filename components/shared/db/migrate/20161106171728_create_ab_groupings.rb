class CreateAbGroupings < ActiveRecord::Migration
  def change
    create_table :ab_groupings do |t|
      t.references :user, index: true, null: false
      t.references :ab_group, index: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :ab_groupings
  end
end
