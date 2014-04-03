class RemoveTaggableFromTaggings < ActiveRecord::Migration
  def up
    remove_column :taggings, :taggable_type
    rename_column :taggings, :taggable_id, :question_id
  end

  def down
    add_column :taggings, :taggable_type, :string

    Tagging.unscoped.update_all(taggable_type: :Question)

    change_column :taggings, :taggable_type, :string, null: false
    rename_column :taggings, :question_id, :taggable_id
  end
end
