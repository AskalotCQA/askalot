class RemoveNonhierarchicalCategories < ActiveRecord::Migration
  def up
    Shared::Category.roots.where.not(name: 'root').delete_all
    Shared::Category.rebuild!
  end
end
