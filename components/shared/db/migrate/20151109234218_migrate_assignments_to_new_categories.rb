class MigrateAssignmentsToNewCategories < ActiveRecord::Migration
  def up
    ActiveRecord::Base.disable_timestamps

    category_regex = /^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/
    category_root = Shared::Category.roots.find_by name: :root
    Shared::Assignment.all.each do |assignment|
      category = assignment.category

      match = category_regex.match(category.name)

      if match
        main_category = match[1].strip
        sub_category = match[2].strip

        category_root.descendants.where(name: main_category).each do |main_category|
          puts "to #{category.name} assigning #{sub_category} in #{main_category.name}"
          assignment.category_id = main_category.children.find_by(name: sub_category).id
          assignment.save!
        end
      else
        category_root.descendants.where(name: category.name, depth: 2).each do |category|
          puts "to #{category.name} assigning"
          assignment.category_id = category.id
          assignment.save!
        end
      end
    end
  end
end