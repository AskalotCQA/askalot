class AddAndIndexColumnsOnTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :author_id, :integer

    add_index :taggings, :author_id
    add_index :taggings, :question_id
  end
end
