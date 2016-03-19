class RemoveNonhierarchicalCategories < ActiveRecord::Migration
  def change
    Shared::Category.roots.where.not(name: 'root').delete_all
    Shared::Category.rebuild!
  end
end
