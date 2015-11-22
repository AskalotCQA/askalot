class MigrateCategoriesToHierarchy < ActiveRecord::Migration
  def up
    categories = Shared::Category.roots.where.not name: 'root'

    root = Shared::Category.roots.find_by! name: 'root'

    years = root.children

    subjects = {}

    categories.each do |category|
      puts "Migrating #{category.name}"
      match = category.name.match(/^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/)
      if match
        puts "\tCategory #{match[1]} with subcategory #{match[2]}"
        years.each do |year|
          puts "\t\tInserting into year #{year.name}"
          if !subjects[year.name]
            puts "\t\tYear not fetched"
            subjects[year.name] = {}
          end
          subject_name = match[1].strip

          if !subjects[year.name][subject_name]
            puts "\t\tSubject not fetched"
            subjects[year.name][subject_name] = year.children.create!(name: subject_name, uuid: subject_name)
          end

          puts "\tSaving"
          Shared::Category.create!({
                               name: match[2].strip,
                               tags: category.tags,
                               uuid: category.name,
                               parent_id: subjects[year.name][subject_name].id,
                               questions_count: category.questions_count,
                               slido_username: category.slido_username,
                               slido_event_prefix: category.slido_event_prefix
                           })
          puts "\tDone"
        end
      else
        puts
        years.each do |year|
          Shared::Category.create!({
                               name: category.name,
                               tags: category.tags,
                               uuid: category.name,
                               parent_id: year.id,
                               questions_count: category.questions_count,
                               slido_username: category.slido_username,
                               slido_event_prefix: category.slido_event_prefix
                           })
        end
      end
      Shared::Category.rebuild!
    end
  end

  def down
    root = Shared::Category.roots.find_by name: 'root'
    root.children.each do |year|
      year.children.delete_all
    end
  end
end