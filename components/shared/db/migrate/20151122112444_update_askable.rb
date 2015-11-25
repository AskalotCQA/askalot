class UpdateAskable < ActiveRecord::Migration
  def up
    unless Shared::Category.roots.find_by(name: 'root').children.empty?
      Shared::Category.roots.find_by(name: 'root').children.sort_by(&:name).last.descendants.update_all(:askable => true)
    end
  end
end