class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :data, null: false

      t.datetime :created_at, null: false
    end

    add_index :events, :created_at
  end
end
