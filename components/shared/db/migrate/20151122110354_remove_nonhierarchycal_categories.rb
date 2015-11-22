class RemoveNonhierarchycalCategories < ActiveRecord::Migration
  def up
    Shared::Category.roots.where.not(name: 'root').destroy_all
  end
end