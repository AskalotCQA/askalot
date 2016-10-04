class CreateListsTables < ActiveRecord::Migration
  def up
    create_table :lists do |t|
      t.references :category,  null: false
      t.references :lister,    null: false
      t.boolean    :unit_view, default: false, null: false
      t.references :deletor

      t.boolean :deleted, default: false, null: false

      t.timestamp :created_at
      t.timestamp :deleted_at
    end

    add_index :lists, :lister_id
    add_index :lists, :category_id
    add_index :lists, :deleted
    add_index :lists, :deletor_id

    add_counter :categories, :lists
    add_counter :users, :lists
  end

  def down
    drop_table :lists

    remove_counter :categories, :lists
    remove_counter :users, :lists
  end
end
