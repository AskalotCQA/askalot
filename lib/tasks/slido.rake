namespace :slido do
  desc 'Pulls new questions for all defined slido users'
  task questions: :environment do
    Category.with_slido do |category|
      Slido::Scraper.run(category)
    end
  end
end
