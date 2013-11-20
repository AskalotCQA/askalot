class ForceNonNullsInTaggings < ActiveRecord::Migration
  def change
    change_column :taggings, :tag_id, :integer, null: false

    change_column :taggings, :taggable_id,   :integer, null: false
    change_column :taggings, :taggable_type, :string,  null: false

    change_column :taggings, :context, :string, null: false, limit: 128
  end
end
