class RemoveUniqueIndexNameAndParentFromCategories < ActiveRecord::Migration
  def change
    remove_index(:categories, name: 'index_categories_on_name_and_parent_id')
  end
end
