class RemoveTaggerFromTaggings < ActiveRecord::Migration
  def change
    remove_column :taggings, :tagger_id,   :integer
    remove_column :taggings, :tagger_type, :string
  end
end
