class MigrateYearsToCategories < ActiveRecord::Migration
  @@YEAR_REGEX = '^20[0-3][0-9]-[0-3][0-9]$'

  def up
    root = Shared::Category.find_or_create_by!(name: 'root')
    Shared::Tag.where('name ~* ?', @@YEAR_REGEX).each do |tag|
      root.children.create name: tag.name
    end
  end

  def down
    root = Shared::Category.roots.find_by! name: 'root'
    root.children.where('name ~* ?', @@YEAR_REGEX).destroy_all
  end
end