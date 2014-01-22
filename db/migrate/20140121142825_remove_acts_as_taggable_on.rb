class RemoveActsAsTaggableOn < ActiveRecord::Migration
  def up
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
    remove_column :taggings, :context

    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type]
  end

  def down
    add_column :taggings, :tagger_id,   :integer
    add_column :taggings, :tagger_type, :string
    add_column :taggings, :context,     :string

    add_index    :taggings,         [:tagger_id,   :tagger_type]
    remove_index :taggings, column: [:taggable_id, :taggable_type]
    remove_index :taggings, column: [:tag_id, :taggable_id, :taggable_type]
  end
end
