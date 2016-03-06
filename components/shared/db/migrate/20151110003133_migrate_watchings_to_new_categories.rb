class MigrateWatchingsToNewCategories < ActiveRecord::Migration
  def up
    category_regex = /^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/
    categoryRoot = Shared::Category.roots.find_by name: :root
    Shared::Watching.unscoped.where(watchable_type: "Category").each do |watching|
      category = Shared::Category.find_by_id watching.watchable_id

      next if category.nil?

      if match = category_regex.match(category.name)
        main_category = match[1].strip
        sub_category = match[2].strip

        categoryRoot.descendants.where(name: main_category).each do |main_category|
          puts "to #{category.name} assigning #{sub_category} in #{main_category.name}"
          watching.watchable_id = main_category.children.find_by(name: sub_category).id
          watching.save!
        end
      else
        categoryRoot.descendants.where(name: category.name, depth: 2).each do |category|
          puts "to #{category.name} assigning"
          watching.watchable_id = category.id
          watching.save!
        end
      end
    end
  end
end