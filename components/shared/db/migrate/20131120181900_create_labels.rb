class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :labels, :value
  end
end
