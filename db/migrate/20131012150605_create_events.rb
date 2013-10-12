class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :data, null: false

      t.datetime :created_ad, null: false
    end

    add_index :events, :created_ad
  end
end
