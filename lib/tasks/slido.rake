namespace :slido do
  desc 'Pulls new questions for all defined slido users'
  task questions: :environment do
    Category.with_slido.each do |category|
      puts "Pulling questions from #{category.slido_username} for category #{category.name}."

      Slido::Scraper.run(category)
    end
  end
end
