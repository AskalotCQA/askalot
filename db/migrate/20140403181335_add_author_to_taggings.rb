class AddAuthorToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :author_id, :integer, null: false

    add_index :taggings, :author_id
    add_index :taggings, [:tag_id, :question_id, :author_id], unique: true
  end
end
