class ForceNonNullOnAuthorInTaggings < ActiveRecord::Migration
  def change
    change_column :taggings, :author_id, :integer, null: false
  end
end
