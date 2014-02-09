class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :author,      null: false
      t.references :commentable, null: false, polymorphic: true

      t.text :text, null: false

      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
