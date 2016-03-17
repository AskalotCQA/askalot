class MigrateSlidoEventsToNewCategories < ActiveRecord::Migration
  def up
    ActiveRecord::Base.record_timestamps = false

    category_regex = /^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/
    categoryRoot = Shared::Category.roots.find_by name: :root
    Shared::SlidoEvent.all.each do |slido_event|
      category = slido_event.category
      if match = category_regex.match(category.name)
        main_category = match[1].strip
        sub_category = match[2].strip

        categoryRoot.descendants.where(name: main_category).each do |main_category|
          puts "to #{category.name} assigning #{sub_category} in #{main_category.name}"
          slido_event.category_id = main_category.children.find_by(name: sub_category).id
          slido_event.save!
        end
      else
        categoryRoot.descendants.where(name: :MIXED).each do |mixed|
          puts "to #{category.name} assigning #{mixed} in MIXED"
          slido_event.category_id = mixed.children.find_by(name: category.name).id
          slido_event.save!
        end
      end
    end
  end
end