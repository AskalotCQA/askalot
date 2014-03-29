class AddIndicesForSlidoAttributes < ActiveRecord::Migration
  def change
    add_index :categories, :slido_username

    add_index :questions, :slido_uuid, unique: true

    add_index :slido_events, :uuid, unique: true
  end
end
