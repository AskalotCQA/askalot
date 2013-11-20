class AddTaggerToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :tagger_id,   :integer
    add_column :taggings, :tagger_type, :string

    add_index :taggings, [:tagger_id, :tagger_type, :context]
  end
end
