class CreateAbGroups < ActiveRecord::Migration
  def change
    create_table :ab_groups do |t|
      t.string :value, null: false

      t.timestamps
    end
  end

  def down
    drop_table :ab_groups
  end
end
