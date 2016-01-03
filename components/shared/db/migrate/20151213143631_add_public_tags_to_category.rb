class AddPublicTagsToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :public_tags, :string, array: true, default: []
    Shared::Category.all.each do |category|
      category.add_tags_to_descendants category.tags if category.tags.size > 0
    end
  end

  def down
    remove_column :categories, :public_tags
  end
end
