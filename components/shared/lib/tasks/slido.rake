namespace :slido do
  desc 'Pulls new questions for all defined slido users'
  task questions: :environment do
    Shared::Category.with_slido.each do |category|
      puts "Pulling questions from #{category.slido_username} for category #{category.name}..."

      # TODO (smolnar) refactor
      begin
        Shared::Slido::Scraper.run(category)
      rescue Exception => e
        puts "Error pulling questions from #{category.slido_username}."
        puts e
      end
    end
  end
end
