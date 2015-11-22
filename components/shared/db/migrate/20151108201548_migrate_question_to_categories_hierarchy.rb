class MigrateQuestionToCategoriesHierarchy < ActiveRecord::Migration
  def up
    root = Shared::Category.roots.find_by name: 'root'
    last_year = root.children.sort_by(&:name).last.name
    Shared::Question.all.each do |question|
      puts "Updating question #{question.id} with category id #{question.category_id}"
      category = question.category
      puts "Category #{question.category}"
      if category
        puts "\tQuestion has category #{category.name}"
        year_tag = question.tags.where('name ~* ?', '^20[0-9][0-9]-[0-9][0-9]$').first
        puts "\tQuestion has year tag #{year_tag}"
        year = (year_tag) ? year_tag.name : last_year
        puts "\tQuestion is from year #{year}"

        match = /^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/.match(category.name)
        if match
          subject = match[1].strip
          subcategory = match[2].strip
          puts "\tQuestion is in subject #{subject} and subcategory #{subcategory}"

          question.category_id = root.children.find_by(name: year).children.find_by(name: subject).children.find_by(name: subcategory).id
          question.save!
        else
          puts "\tQuestion is direct"
          question.category_id = root.children.find_by(name: year).children.find_by(name: category.name).id
          question.save!
        end
      else
        puts "\tQuestion without category #{question.id}, #{question.category_id} should by null"
      end
    end
  end
end