class CreateCommentRevisions < ActiveRecord::Migration
  def change
    create_table :comment_revisions do |t|
      t.references :comment,   null: false
      t.references :editor,   null: false

      t.text :text, null: false

      t.timestamps
    end

    add_index :comment_revisions, :comment_id
    add_index :comment_revisions, :editor_id
  end
end
