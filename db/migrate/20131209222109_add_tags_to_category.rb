class AddTagsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :tags, :string, array: true, default: []
  end
end
