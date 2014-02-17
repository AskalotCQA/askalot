namespace :slido do
  desc 'Pulls new questions for all defined slido users'
  task questions: :environment do
    Category.with_slido.each do |category|
      puts "Pulling questions from #{category.slido_username} for category #{category.name}..."

      # TODO (smolnar) refactor
      begin
        Slido::Scraper.run(category)
      rescue
        puts "Error pulling questions from #{category.slido_username}."
      end
    end
  end
end
