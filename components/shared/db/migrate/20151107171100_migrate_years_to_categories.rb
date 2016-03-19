class MigrateYearsToCategories < ActiveRecord::Migration
  @@YEAR_REGEX = '^20[0-3][0-9]-[0-3][0-9]$'

  def up
    root = Shared::Category.find_or_create_by!(name: 'root')
    Shared::Tag.where('name ~* ?', @@YEAR_REGEX).each do |tag|
      year = root.children.create name: tag.name, tags: [tag.name], uuid: tag.name

      year.children.create name: 'Bc. štúdium (štvorročné) - 1. ročník', tags: ['4bc-1-rocnik'], uuid: '4bc-1-rocnik'
      year.children.create name: 'Bc. štúdium - 1. ročník', tags: ['bc-1-rocnik'], uuid: 'bc-1-rocnik'
      year.children.create name: 'Bc. štúdium - 2. ročník', tags: ['bc-2-rocnik'], uuid: 'bc-2-rocnik'
      year.children.create name: 'Bc. štúdium - 3. ročník', tags: ['bc-3-rocnik'], uuid: 'bc-3-rocnik'
      year.children.create name: 'Ing. štúdium - 1. a 2. ročník', tags: ['ing-1-2-rocnik'], uuid: 'ing-1-2-rocnik'
      year.children.create name: 'Všeobecné', tags: [], uuid: 'vseobecne'
    end
  end

  def down
    root = Shared::Category.roots.find_by! name: 'root'
    root.children.where('name ~* ?', @@YEAR_REGEX).destroy_all
  end
end
