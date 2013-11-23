class CreateComment < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :author_id,      null: false,
      t.references :commentable_id, null: false,

      t.string :commentable_type

      t.string :text, null: false

      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, :commentable_id

  end
end
