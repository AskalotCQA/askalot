class CreateSlidoEvents < ActiveRecord::Migration
  def change
    create_table :slido_events do |t|
      t.references :category, null: false

      t.integer    :uuid,       null: false
      t.string     :identifier, null: false
      t.string     :name,       null: false
      t.string     :url,        null: false

      t.datetime   :started_at, null: false
      t.datetime   :ended_at,   null: false

      t.timestamps
    end

    add_index :slido_events, :category_id

    add_index :slido_events, :started_at
    add_index :slido_events, :ended_at
  end
end
