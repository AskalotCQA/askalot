class AddUpdatedAtToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :updated_at, :datetime
  end
end
